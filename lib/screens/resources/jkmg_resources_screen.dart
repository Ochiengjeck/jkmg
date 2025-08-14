import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../models/resource.dart';
import '../../provider/api_providers.dart';
import '../../widgets/common_widgets.dart';
import 'resource_detail_screen.dart';

// Create a simple provider for resources by type similar to allEventsProvider
final resourcesByTypeProvider = FutureProvider.autoDispose
    .family<List<Resource>, String?>((ref, type) async {
      final apiService = ref.read(apiServiceProvider);
      try {
        final response = await apiService.getResources(type: type, perPage: 50);
        return response.data;
      } catch (e) {
        // If authentication fails, return empty response
        if (e.toString().contains('unauthenticated') ||
            e.toString().contains('401')) {
          return [];
        }
        rethrow;
      }
    });

class JKMGResourcesScreen extends ConsumerStatefulWidget {
  const JKMGResourcesScreen({super.key});

  @override
  ConsumerState<JKMGResourcesScreen> createState() =>
      _JKMGResourcesScreenState();
}

class _JKMGResourcesScreenState extends ConsumerState<JKMGResourcesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Hero section above tabs
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildHeroSection(),
            ),
            const SizedBox(height: 16),
            // Tabs below hero section
            _buildTabBar(),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    color: AppTheme.richBlack,
                    child: ResourcesTabContent(type: null),
                  ),
                  Container(
                    color: AppTheme.richBlack,
                    child: ResourcesTabContent(type: 'ebook'),
                  ),
                  Container(
                    color: AppTheme.richBlack,
                    child: ResourcesTabContent(type: 'audiobook'),
                  ),
                  Container(
                    color: AppTheme.richBlack,
                    child: ResourcesTabContent(type: 'sermon'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Clean image section without overlays
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
                width: 1,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/resources.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Separate text content section with modern design
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.charcoalBlack,
                  AppTheme.richBlack,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Description
                const Text(
                  'Expanding Your Kingdom Knowledge',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Access comprehensive digital resources for spiritual growth',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Feature highlights in single row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureChip('E-Books'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Audiobooks'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Sermons'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Study Materials'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.primaryGold,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.white60,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        dividerHeight: 0,
        indicator: BoxDecoration(
          color: AppTheme.primaryGold,
          borderRadius: BorderRadius.circular(20),
        ),
        indicatorPadding: const EdgeInsets.symmetric(vertical: 3),
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          SizedBox(
            width: 80,
            child: Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.library_books, size: 14),
                  SizedBox(height: 2),
                  Text('All', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.menu_book, size: 14),
                  SizedBox(height: 2),
                  Text('E-Books', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.headphones, size: 14),
                  SizedBox(height: 2),
                  Text('Audio', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.play_circle, size: 14),
                  SizedBox(height: 2),
                  Text('Sermons', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResourcesTabContent extends ConsumerWidget {
  final String? type;

  const ResourcesTabContent({super.key, this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAboutSection(),
          const SizedBox(height: 24),
          _buildResourceList(ref),
          const SizedBox(height: 24),
          _buildImpactMetrics(),
          const SizedBox(height: 24),
          _buildAccessSection(),
        ],
      ),
    );
  }


  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'About Digital Resources',
          subtitle: 'Your gateway to kingdom knowledge and spiritual growth',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.accentGold.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAboutPoint(
                'Our Mission',
                'Empowering believers with accessible, high-quality digital content for spiritual growth and Kingdom advancement',
              ),
              const SizedBox(height: 12),
              _buildAboutPoint(
                'What We Offer',
                'A comprehensive library of e-books, audiobooks, sermons, and study materials designed to deepen your faith journey',
              ),
              const SizedBox(height: 12),
              _buildAboutPoint(
                'Quality Assurance',
                'All content is carefully curated and reviewed to ensure biblical accuracy and practical application',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutPoint(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.deepGold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceList(WidgetRef ref) {
    final resourcesAsync = ref.watch(resourcesByTypeProvider(type));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: type == null
              ? 'All Resources'
              : '${_getTypeName(type!)} Resources',
          subtitle: 'Browse our curated collection',
        ),
        const SizedBox(height: 12),
        resourcesAsync.when(
          data: (resources) => _buildResourceGrid(resources),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: AppTheme.primaryGold),
            ),
          ),
          error: (error, stack) => _buildErrorState(
            () => ref.refresh(resourcesByTypeProvider(type)),
          ),
        ),
      ],
    );
  }

  Widget _buildResourceGrid(List<Resource> resources) {
    if (resources.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No resources available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new content',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Column(
      children: resources
          .map(
            (resource) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ModernResourceCard(resource: resource),
            ),
          )
          .toList(),
    );
  }

  Widget _buildErrorState(VoidCallback onRetry) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.errorRed),
          const SizedBox(height: 16),
          const Text(
            'Failed to load resources',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.richBlack,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Our Impact',
          subtitle: 'Transforming lives through digital resources',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                '2,500+',
                'Resources\nAvailable',
                Icons.library_books,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                '50K+',
                'Downloads\nCompleted',
                Icons.download,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                '25+',
                'Languages\nSupported',
                Icons.translate,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard('4.8★', 'Average\nRating', Icons.star),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String number, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.1),
            AppTheme.accentGold.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.deepGold, size: 28),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.deepGold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccessSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.charcoalBlack,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.download,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Access Digital Resources',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Download, stream, or read online. All resources are available across multiple formats for your convenience. Access premium content with your JKMG membership.',
            style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAccessOption(
                  'Download',
                  Icons.download,
                  'Offline access',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAccessOption(
                  'Stream',
                  Icons.play_arrow,
                  'Online streaming',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAccessOption(
                  'Read',
                  Icons.menu_book,
                  'Digital reading',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to member login or registration
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Join JKMG for Premium Access'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessOption(String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.softBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryGold, size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getTypeName(String type) {
    switch (type) {
      case 'ebook':
        return 'E-Book';
      case 'audiobook':
        return 'Audiobook';
      case 'sermon':
        return 'Sermon';
      default:
        return type.substring(0, 1).toUpperCase() + type.substring(1);
    }
  }
}

class ModernResourceCard extends StatelessWidget {
  final Resource resource;

  const ModernResourceCard({super.key, required this.resource});

  IconData _getResourceIcon() {
    switch (resource.type.value) {
      case 'ebook':
        return Icons.menu_book;
      case 'audiobook':
        return Icons.headphones;
      case 'sermon':
        return Icons.play_circle;
      default:
        return Icons.description;
    }
  }

  Color _getResourceColor() {
    switch (resource.type.value) {
      case 'ebook':
        return AppTheme.primaryGold;
      case 'audiobook':
        return AppTheme.deepGold;
      case 'sermon':
        return AppTheme.darkGold;
      default:
        return AppTheme.successGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ResourceDetailScreen(resourceId: resource.id.toString()),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getResourceColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getResourceIcon(),
                  color: _getResourceColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            resource.displayTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getResourceColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            resource.type.label,
                            style: TextStyle(
                              color: _getResourceColor(),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      resource.displayDescription,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          resource.displayLanguage,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppTheme.primaryGold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
