import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class ChatDatabaseService {
  static Database? _database;
  static const String _databaseName = 'chat_database.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _conversationsTable = 'conversations';
  static const String _messagesTable = 'messages';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create conversations table
    await db.execute('''
      CREATE TABLE $_conversationsTable (
        id TEXT PRIMARY KEY,
        counsellor_id TEXT NOT NULL,
        counsellor_name TEXT NOT NULL,
        counsellor_specialization TEXT,
        counsellor_avatar TEXT,
        last_message TEXT,
        last_message_time INTEGER,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');

    // Create messages table
    await db.execute('''
      CREATE TABLE $_messagesTable (
        id TEXT PRIMARY KEY,
        conversation_id TEXT NOT NULL,
        message TEXT NOT NULL,
        is_from_user INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        message_type TEXT DEFAULT 'text',
        metadata TEXT,
        FOREIGN KEY (conversation_id) REFERENCES $_conversationsTable (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('''
      CREATE INDEX idx_messages_conversation_id ON $_messagesTable (conversation_id)
    ''');
    await db.execute('''
      CREATE INDEX idx_messages_timestamp ON $_messagesTable (timestamp)
    ''');
    await db.execute('''
      CREATE INDEX idx_conversations_updated_at ON $_conversationsTable (updated_at)
    ''');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Future upgrade logic
    }
  }

  // Conversation methods
  static Future<String> createOrUpdateConversation({
    required String conversationId,
    required String counsellorId,
    required String counsellorName,
    String? counsellorSpecialization,
    String? counsellorAvatar,
    String? lastMessage,
  }) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final conversationData = {
      'id': conversationId,
      'counsellor_id': counsellorId,
      'counsellor_name': counsellorName,
      'counsellor_specialization': counsellorSpecialization,
      'counsellor_avatar': counsellorAvatar,
      'last_message': lastMessage,
      'last_message_time': lastMessage != null ? now : null,
      'created_at': now,
      'updated_at': now,
    };

    await db.insert(
      _conversationsTable,
      conversationData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return conversationId;
  }

  static Future<void> updateConversationLastMessage({
    required String conversationId,
    required String lastMessage,
  }) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.update(
      _conversationsTable,
      {
        'last_message': lastMessage,
        'last_message_time': now,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [conversationId],
    );
  }

  static Future<List<Map<String, dynamic>>> getConversations() async {
    final db = await database;
    return await db.query(
      _conversationsTable,
      orderBy: 'updated_at DESC',
    );
  }

  static Future<Map<String, dynamic>?> getConversation(String conversationId) async {
    final db = await database;
    final results = await db.query(
      _conversationsTable,
      where: 'id = ?',
      whereArgs: [conversationId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Message methods
  static Future<void> saveMessage({
    required String messageId,
    required String conversationId,
    required String message,
    required bool isFromUser,
    DateTime? timestamp,
    String messageType = 'text',
    Map<String, dynamic>? metadata,
  }) async {
    final db = await database;
    final messageTimestamp = timestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;

    final messageData = {
      'id': messageId,
      'conversation_id': conversationId,
      'message': message,
      'is_from_user': isFromUser ? 1 : 0,
      'timestamp': messageTimestamp,
      'message_type': messageType,
      'metadata': metadata != null ? jsonEncode(metadata) : null,
    };

    await db.insert(
      _messagesTable,
      messageData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Update conversation's last message
    if (!isFromUser || message.isNotEmpty) {
      await updateConversationLastMessage(
        conversationId: conversationId,
        lastMessage: message,
      );
    }
  }

  static Future<List<Map<String, dynamic>>> getMessages(String conversationId, {
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    String sql = 'SELECT * FROM $_messagesTable WHERE conversation_id = ? ORDER BY timestamp ASC';
    List<dynamic> args = [conversationId];

    if (limit != null) {
      sql += ' LIMIT ?';
      args.add(limit);
      if (offset != null) {
        sql += ' OFFSET ?';
        args.add(offset);
      }
    }

    return await db.rawQuery(sql, args);
  }

  static Future<void> deleteConversation(String conversationId) async {
    final db = await database;
    
    // Delete messages first (foreign key constraint will handle this automatically)
    await db.delete(
      _messagesTable,
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
    );
    
    // Delete conversation
    await db.delete(
      _conversationsTable,
      where: 'id = ?',
      whereArgs: [conversationId],
    );
  }

  static Future<void> clearAllData() async {
    final db = await database;
    await db.delete(_messagesTable);
    await db.delete(_conversationsTable);
  }

  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Utility method to convert database message to ChatMessage
  static Map<String, dynamic> messageFromDatabase(Map<String, dynamic> dbMessage) {
    return {
      'id': dbMessage['id'],
      'conversation_id': dbMessage['conversation_id'],
      'message': dbMessage['message'],
      'is_from_user': dbMessage['is_from_user'] == 1,
      'timestamp': DateTime.fromMillisecondsSinceEpoch(dbMessage['timestamp']),
      'message_type': dbMessage['message_type'] ?? 'text',
      'metadata': dbMessage['metadata'] != null 
          ? jsonDecode(dbMessage['metadata'])
          : null,
    };
  }

  // Search messages
  static Future<List<Map<String, dynamic>>> searchMessages(String query, {
    String? conversationId,
    int? limit,
  }) async {
    final db = await database;
    String sql = 'SELECT * FROM $_messagesTable WHERE message LIKE ?';
    List<dynamic> args = ['%$query%'];

    if (conversationId != null) {
      sql += ' AND conversation_id = ?';
      args.add(conversationId);
    }

    sql += ' ORDER BY timestamp DESC';

    if (limit != null) {
      sql += ' LIMIT ?';
      args.add(limit);
    }

    return await db.rawQuery(sql, args);
  }

  // Get conversation stats
  static Future<Map<String, int>> getConversationStats(String conversationId) async {
    final db = await database;
    
    final totalMessages = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_messagesTable WHERE conversation_id = ?',
      [conversationId],
    );
    
    final userMessages = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_messagesTable WHERE conversation_id = ? AND is_from_user = 1',
      [conversationId],
    );
    
    final counsellorMessages = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_messagesTable WHERE conversation_id = ? AND is_from_user = 0',
      [conversationId],
    );

    return {
      'total_messages': totalMessages.first['count'] as int,
      'user_messages': userMessages.first['count'] as int,
      'counsellor_messages': counsellorMessages.first['count'] as int,
    };
  }
}