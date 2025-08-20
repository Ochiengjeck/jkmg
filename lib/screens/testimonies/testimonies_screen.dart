import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../models/testimony.dart';
import '../../provider/api_providers.dart';
import 'submit_testimony_screen.dart';
import 'testimony_detail_screen.dart';
import 'my_testimonies_screen.dart';

// Simple provider for all testimonies similar to allEventsProvider
final allTestimoniesProvider = FutureProvider<List<Testimony>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getTestimonies(perPage: 50);
    return response.data.where((t) => t.isApproved).toList();
  } catch (e) {
    // If authentication fails, return empty response
    if (e.toString().contains('unauthenticated') ||
        e.toString().contains('401')) {
      return [];
    }
    rethrow;
  }
});

class TestimoniesScreen extends ConsumerStatefulWidget {
  const TestimoniesScreen({super.key});

  @override
  ConsumerState<TestimoniesScreen> createState() => _TestimoniesScreenState();
}

class _TestimoniesScreenState extends ConsumerState<TestimoniesScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.primaryGoldGradient.createShader(bounds),
          child: const Text(
            'Testimonies',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppTheme.primaryGold,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: AppTheme.primaryGold,
                size: 20,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'submit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubmitTestimonyScreen(),
                      ),
                    );
                    break;
                  case 'my_testimonies':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyTestimoniesScreen(),
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'submit',
                  child: Row(
                    children: [
                      Icon(Icons.add, color: AppTheme.primaryGold),
                      SizedBox(width: 8),
                      Text('Submit Testimony'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'my_testimonies',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: AppTheme.primaryGold),
                      SizedBox(width: 8),
                      Text('My Testimonies'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.darkBackgroundGradient,
        ),
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight + 40),
                  _buildHeader(),
                  Expanded(child: _buildTestimoniesList()),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubmitTestimonyScreen()),
          );
        },
        backgroundColor: AppTheme.primaryGold,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Share Testimony',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.1),
            AppTheme.primaryGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.favorite, size: 48, color: AppTheme.primaryGold),
          const SizedBox(height: 12),
          const Text(
            'Testimonies of Faith',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Read inspiring stories of God\'s goodness and share your own testimony to encourage others in their faith journey.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimoniesList() {
    final testimoniesAsync = ref.watch(allTestimoniesProvider);

    return testimoniesAsync.when(
      data: (testimonies) {
        if (testimonies.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.refresh(allTestimoniesProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: testimonies.length,
            itemBuilder: (context, index) {
              final testimony = testimonies[index];
              return TestimonyCard(
                testimony: testimony,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TestimonyDetailScreen(testimony: testimony),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
        ),
      ),
      error: (error, stack) => _buildErrorState(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          Text(
            'No Testimonies Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Be the first to share your testimony\nand inspire others!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SubmitTestimonyScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Share Your Testimony'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
          const SizedBox(height: 24),
          Text(
            'Failed to Load Testimonies',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.refresh(allTestimoniesProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class TestimonyCard extends StatelessWidget {
  final Testimony testimony;
  final VoidCallback onTap;

  const TestimonyCard({
    super.key,
    required this.testimony,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryGold.withOpacity(0.1),
                    child: Text(
                      testimony.user.initials,
                      style: const TextStyle(
                        color: AppTheme.primaryGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testimony.displayUserName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(testimony.createdAt),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (testimony.hasValidMedia)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.attachment,
                        size: 16,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                testimony.displayTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                testimony.displayExcerpt,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: testimony.isApproved
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      testimony.status.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: testimony.isApproved
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                  Text(
                    'Read more',
                    style: TextStyle(
                      color: AppTheme.primaryGold,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()} weeks ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
