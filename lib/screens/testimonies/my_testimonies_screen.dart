import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../models/testimony.dart';
import '../../provider/api_providers.dart';
import 'submit_testimony_screen.dart';
import 'testimony_detail_screen.dart';

// Simple provider for user's testimonies
final myTestimoniesListProvider = FutureProvider<List<Testimony>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getMyTestimonies(perPage: 50);
    return response.data;
  } catch (e) {
    // If authentication fails, return empty response
    if (e.toString().contains('unauthenticated') || e.toString().contains('401')) {
      return [];
    }
    rethrow;
  }
});

class MyTestimoniesScreen extends ConsumerWidget {
  const MyTestimoniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testimoniesAsync = ref.watch(myTestimoniesListProvider);

    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGoldGradient.createShader(bounds),
          child: const Text(
            'My Testimonies',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: Colors.white,
              letterSpacing: 0.3,
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
            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryGold, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.darkBackgroundGradient,
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 40),
            _buildHeader(context),
            Expanded(
            child: testimoniesAsync.when(
              data: (testimonies) {
                if (testimonies.isEmpty) {
                  return _buildEmptyState(context, ref);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(myTestimoniesListProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: testimonies.length,
                    itemBuilder: (context, index) {
                      final testimony = testimonies[index];
                      return MyTestimonyCard(
                        testimony: testimony,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TestimonyDetailScreen(testimony: testimony),
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
              error: (error, stack) => _buildErrorState(context, ref),
            ),
          ),
        ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SubmitTestimonyScreen(),
            ),
          ).then((_) {
            // Refresh testimonies when returning from submit screen
            ref.refresh(myTestimoniesListProvider);
          });
        },
        backgroundColor: AppTheme.primaryGold,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Testimony',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryGold.withOpacity(0.1), AppTheme.primaryGold.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_outline,
            size: 48,
            color: AppTheme.primaryGold,
          ),
          const SizedBox(height: 12),
          const Text(
            'My Testimonies',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'View and manage all the testimonies you\'ve shared with the community.',
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

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey.shade300,
          ),
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
            'Share your first testimony and\ninspire others with your story!',
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
              ).then((_) {
                ref.refresh(myTestimoniesListProvider);
              });
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

  Widget _buildErrorState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.shade300,
          ),
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
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.refresh(myTestimoniesListProvider);
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

class MyTestimonyCard extends StatelessWidget {
  final Testimony testimony;
  final VoidCallback onTap;

  const MyTestimonyCard({
    super.key,
    required this.testimony,
    required this.onTap,
  });

  Color get _statusColor {
    switch (testimony.displayStatus.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get _statusIcon {
    switch (testimony.displayStatus.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 4),
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
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _statusIcon,
                              size: 14,
                              color: _statusColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              testimony.status.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (testimony.hasValidMedia) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.attachment,
                            size: 14,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                  _buildStatusHelper(),
                  Text(
                    'View details',
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

  Widget _buildStatusHelper() {
    String helperText;
    switch (testimony.displayStatus.toLowerCase()) {
      case 'approved':
        helperText = 'Published to community';
        break;
      case 'pending':
        helperText = 'Under review';
        break;
      case 'rejected':
        helperText = 'Not approved';
        break;
      default:
        helperText = 'Status unknown';
    }

    return Text(
      helperText,
      style: TextStyle(
        color: _statusColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
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