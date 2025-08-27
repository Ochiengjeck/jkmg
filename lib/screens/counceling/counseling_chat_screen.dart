import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../utils/app_theme.dart';
import '../../provider/api_providers.dart';
import '../../services/preference_service.dart';
import '../../services/chat_database_service.dart';

class CounselingChatScreen extends ConsumerStatefulWidget {
  final dynamic counsellor;

  const CounselingChatScreen({
    super.key,
    required this.counsellor,
  });

  @override
  ConsumerState<CounselingChatScreen> createState() => _CounselingChatScreenState();
}

class _CounselingChatScreenState extends ConsumerState<CounselingChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingAnimationController;
  
  List<ChatMessage> _messages = [];
  String? _conversationId;
  bool _isLoading = false;
  bool _isTyping = false;
  bool _isInitialized = false;
  String? _cachedConversationKey;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _cachedConversationKey = 'conversation_${widget.counsellor['id']}';
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check for existing conversation in cache
      final prefs = await PreferenceService.getInstance();
      final cachedConversationId = prefs.getString(_cachedConversationKey!);
      
      if (cachedConversationId != null && _isValidConversationId(cachedConversationId)) {
        _conversationId = cachedConversationId;
        await _loadLocalMessages();
      } else if (cachedConversationId != null) {
        // Clear invalid cached conversation ID
        await prefs.remove(_cachedConversationKey!);
      }
      
      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to initialize chat: $e');
    }
  }

  Future<void> _loadLocalMessages() async {
    if (_conversationId == null) return;

    try {
      final dbMessages = await ChatDatabaseService.getMessages(_conversationId!);
      
      final messages = dbMessages.map((dbMsg) {
        final messageData = ChatDatabaseService.messageFromDatabase(dbMsg);
        return ChatMessage(
          id: messageData['id'],
          text: messageData['message'],
          isFromUser: messageData['is_from_user'],
          timestamp: messageData['timestamp'],
        );
      }).toList();
      
      setState(() {
        _messages = messages;
      });
      
      _scrollToBottom();
    } catch (e) {
      print('Error loading local messages: $e');
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    // Conversation ID will be provided by the API stream if it doesn't exist
    // For now, create a temporary ID to save the user message
    String tempConversationId = _conversationId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _isTyping = true;
    });

    // Save user message to database (will be updated with real conversation ID later if needed)
    await ChatDatabaseService.saveMessage(
      messageId: userMessage.id,
      conversationId: tempConversationId,
      message: userMessage.text,
      isFromUser: true,
      timestamp: userMessage.timestamp,
    );

    _messageController.clear();
    _scrollToBottom();
    _startTypingAnimation();

    final apiService = ref.read(apiServiceProvider);
    
    // Create a placeholder bot message that we'll update as we receive the stream
    final botMessage = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: '',
      isFromUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(botMessage);
      _isTyping = false;
    });
    _stopTypingAnimation();

    String fullResponse = '';
    bool hasReceivedResponse = false;
    
    try {
      print('🚀 Starting to listen to stream...');
      
      // Use await for loop for processing stream data
      await for (final streamData in apiService.startCounsellingChatStream(
        counsellorId: widget.counsellor['id'],
        message: text.trim(),
        conversationId: _conversationId?.startsWith('temp_') == true ? null : _conversationId,
      ).timeout(const Duration(seconds: 60))) {
        print('🔄 Stream data received in UI: $streamData');
        
        // Handle different types of stream data
        final type = streamData['type'] ?? 'content';
        
        if (type == 'metadata') {
          // Handle conversation metadata
          if (streamData['conversation_id'] != null && _conversationId == null) {
            _conversationId = streamData['conversation_id'].toString();
            final prefs = await PreferenceService.getInstance();
            await prefs.setString(_cachedConversationKey!, _conversationId!);
            
            // Create conversation record in database
            await ChatDatabaseService.createOrUpdateConversation(
              conversationId: _conversationId!,
              counsellorId: widget.counsellor['id'],
              counsellorName: widget.counsellor['name'] ?? 'Healing Guide',
              counsellorSpecialization: widget.counsellor['specialization'],
              counsellorAvatar: widget.counsellor['avatar'],
            );
            
            print('✅ Conversation created with ID: $_conversationId');
          }
        } else if (type == 'content') {
          // Handle content chunks
          final content = streamData['content'] ?? '';
          fullResponse += content;
          hasReceivedResponse = true;
          
          print('📝 Updated response: "$fullResponse"');
          
          // Update the bot message with the accumulated response
          final updatedBotMessage = ChatMessage(
            id: botMessage.id,
            text: fullResponse,
            isFromUser: false,
            timestamp: botMessage.timestamp,
          );

          if (mounted) {
            setState(() {
              _messages[_messages.length - 1] = updatedBotMessage;
            });
            
            _scrollToBottom();
          }
        } else if (type == 'complete') {
          // Handle completion - don't add this to the chat UI, just handle cleanup
          print('✅ Stream completed: ${streamData['message']}');
          
          // Save the complete bot message to database
          if (fullResponse.isNotEmpty && _conversationId != null) {
            await ChatDatabaseService.saveMessage(
              messageId: botMessage.id,
              conversationId: _conversationId!,
              message: fullResponse,
              isFromUser: false,
              timestamp: botMessage.timestamp,
            );
            
            // If we started with a temp conversation ID, update the user message too
            if (tempConversationId.startsWith('temp_') && _conversationId != tempConversationId) {
              await ChatDatabaseService.saveMessage(
                messageId: userMessage.id,
                conversationId: _conversationId!,
                message: userMessage.text,
                isFromUser: true,
                timestamp: userMessage.timestamp,
              );
            }
          }
          
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          
          break; // Exit the loop when complete
        }
      }
      
      print('✅ Stream processing completed');

    } catch (e) {
      print('💥 Error in _sendMessage: $e');
      
      // Show error message in chat if we haven't received any content
      if (mounted && !hasReceivedResponse) {
        final errorMessage = ChatMessage(
          id: botMessage.id,
          text: 'Sorry, I\'m having trouble responding right now. Please try again.',
          isFromUser: false,
          timestamp: botMessage.timestamp,
        );

        setState(() {
          _messages[_messages.length - 1] = errorMessage;
          _isLoading = false;
          _isTyping = false;
        });
        _stopTypingAnimation();
      } else if (mounted) {
        setState(() {
          _isLoading = false;
          _isTyping = false;
        });
        _stopTypingAnimation();
        _showError('Failed to send message: $e');
      }
    } finally {
      // Ensure we always clean up the loading state
      if (mounted) {
        print('🧹 Cleaning up loading state...');
        setState(() {
          _isLoading = false;
          _isTyping = false;
        });
        _stopTypingAnimation();
      }
    }
  }

  void _startTypingAnimation() {
    _typingAnimationController.repeat();
  }

  void _stopTypingAnimation() {
    _typingAnimationController.stop();
    _typingAnimationController.reset();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }
  
  // Validate conversation ID format (should be UUID or null)
  bool _isValidConversationId(String? id) {
    if (id == null || id.startsWith('temp_')) {
      return false;
    }
    // Check if it's a UUID format (basic validation)
    final uuidRegex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');
    return uuidRegex.hasMatch(id);
  }
  
  // Debug method to test streaming directly
  Future<void> _testStreaming() async {
    print('🧪 Testing streaming directly...');
    final apiService = ref.read(apiServiceProvider);
    
    try {
      int eventCount = 0;
      await for (final streamData in apiService.startCounsellingChatStream(
        counsellorId: widget.counsellor['id'],
        message: 'Test message',
        conversationId: _conversationId,
      ).timeout(const Duration(seconds: 10))) {
        eventCount++;
        print('🧪 Event $eventCount: $streamData');
        
        if (eventCount > 20) {
          print('🛑 Stopping test after 20 events');
          break;
        }
      }
      print('🧪 Test completed with $eventCount events');
    } catch (e) {
      print('🧪 Test error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final counsellorName = widget.counsellor['name'] ?? 'Healing Guide';
    final isOnline = widget.counsellor['is_online'] ?? true;

    return Scaffold(
      backgroundColor: AppTheme.charcoalBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.richBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () => _showCounsellorDetailsDialog(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryGold, AppTheme.deepGold],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryGold,
                    width: 1,
                  ),
                ),
                child: widget.counsellor['avatar'] != null && widget.counsellor['avatar'].isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Image.network(
                          widget.counsellor['avatar'],
                          width: 34,
                          height: 34,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.psychology,
                              size: 20,
                              color: AppTheme.richBlack,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: AppTheme.richBlack,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.psychology,
                        size: 20,
                        color: AppTheme.richBlack,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    counsellorName,
                    style: const TextStyle(
                      color: AppTheme.primaryGold,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOnline ? 'Online • Ready to help' : 'Offline',
                        style: TextStyle(
                          color: isOnline ? Colors.green : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Debug button - remove in production
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.orange),
            onPressed: _testStreaming,
            tooltip: 'Test Streaming',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppTheme.primaryGold),
            onPressed: _showCounsellorInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoading && !_isInitialized)
            Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Connecting to your guide...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _buildMessagesList(),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (_messages.isEmpty && _isInitialized) {
      return _buildWelcomeMessage();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildWelcomeMessage() {
    final counsellorName = widget.counsellor['name'] ?? 'Healing Guide';
    final specialty = widget.counsellor['specialty'] ?? 'General Guidance';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryGold.withOpacity(0.2),
                    AppTheme.primaryGold.withOpacity(0.1),
                    AppTheme.primaryGold.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                size: 60,
                color: AppTheme.primaryGold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to your healing space',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryGold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re now connected with $counsellorName',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Specializing in $specialty',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryGold.withOpacity(0.3),
                ),
              ),
              child: const Text(
                'Share what\'s on your heart. I\'m here to listen, support, and guide you with biblical wisdom and compassionate care.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isFromUser) ...[
            GestureDetector(
              onTap: () => _showCounsellorDetailsDialog(),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryGold, AppTheme.deepGold],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryGold,
                    width: 1,
                  ),
                ),
                child: widget.counsellor['avatar'] != null && widget.counsellor['avatar'].isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          widget.counsellor['avatar'],
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.psychology,
                              size: 16,
                              color: AppTheme.richBlack,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: AppTheme.richBlack,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.psychology,
                        size: 16,
                        color: AppTheme.richBlack,
                      ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromUser
                    ? AppTheme.primaryGold
                    : AppTheme.richBlack,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isFromUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isFromUser ? 4 : 16),
                ),
                border: message.isFromUser
                    ? null
                    : Border.all(
                        color: AppTheme.primaryGold.withOpacity(0.3),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isFromUser
                          ? AppTheme.richBlack
                          : Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isFromUser
                          ? AppTheme.richBlack.withOpacity(0.7)
                          : Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isFromUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: AppTheme.primaryGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppTheme.richBlack,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGold, AppTheme.deepGold],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology,
              size: 16,
              color: AppTheme.richBlack,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.richBlack,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Typing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        final delay = index * 0.3;
                        final animValue = (_typingAnimationController.value - delay).clamp(0.0, 1.0);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          child: Transform.scale(
                            scale: 0.5 + (0.5 * (1 - (animValue - 0.5).abs() * 2).clamp(0.0, 1.0)),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryGold,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.richBlack,
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryGold.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.charcoalBlack,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppTheme.primaryGold.withOpacity(0.3),
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Share what\'s on your heart...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: _isLoading ? null : _sendMessage,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGold, AppTheme.deepGold],
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _isLoading 
                    ? null 
                    : () => _sendMessage(_messageController.text),
                icon: Icon(
                  Icons.send,
                  color: _isLoading ? Colors.grey : AppTheme.richBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showCounsellorDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.charcoalBlack,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryGold.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with large avatar
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryGold, AppTheme.deepGold],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryGold,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGold.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: widget.counsellor['avatar'] != null && widget.counsellor['avatar'].isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(37),
                            child: Image.network(
                              widget.counsellor['avatar'],
                              width: 74,
                              height: 74,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.psychology,
                                  size: 40,
                                  color: AppTheme.richBlack,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.psychology,
                            size: 40,
                            color: AppTheme.richBlack,
                          ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.counsellor['name'] ?? 'Healing Guide',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.counsellor['specialization'] ?? 'General Guidance',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: widget.counsellor['is_online'] ?? true ? Colors.green : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.counsellor['is_online'] ?? true ? 'Online • Available' : 'Offline',
                              style: TextStyle(
                                color: widget.counsellor['is_online'] ?? true ? Colors.green : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Personality description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryGold.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.psychology_outlined,
                          color: AppTheme.primaryGold,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'About This Counsellor',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.counsellor['personality'] ?? 'A compassionate guide ready to support you on your healing journey.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              if (widget.counsellor['gender'] != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.counsellor['gender'] == 'male' ? Icons.male : Icons.female,
                        color: Colors.blue,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.counsellor['gender'] == 'male' ? 'Male Counsellor' : 'Female Counsellor',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.richBlack,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Continue Conversation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCounsellorInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalBlack,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGold, AppTheme.deepGold],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryGold,
                  width: 1,
                ),
              ),
              child: widget.counsellor['avatar'] != null && widget.counsellor['avatar'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: Image.network(
                        widget.counsellor['avatar'],
                        width: 34,
                        height: 34,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.psychology,
                            size: 20,
                            color: AppTheme.richBlack,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: AppTheme.richBlack,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.psychology,
                      size: 20,
                      color: AppTheme.richBlack,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.counsellor['name'] ?? 'Healing Guide',
                style: const TextStyle(
                  color: AppTheme.primaryGold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specialty: ${widget.counsellor['specialty'] ?? 'General Guidance'}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.counsellor['description'] ?? 'A compassionate guide ready to support you on your healing journey.',
              style: const TextStyle(
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryGold.withOpacity(0.3),
                ),
              ),
              child: const Text(
                'Your conversations are confidential and secure. Feel free to share openly.',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.primaryGold),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'].toString(),
      text: json['message'] ?? '',
      isFromUser: json['sender_type'] == 'user',
      timestamp: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': text,
      'sender_type': isFromUser ? 'user' : 'counsellor',
      'created_at': timestamp.toIso8601String(),
    };
  }
}