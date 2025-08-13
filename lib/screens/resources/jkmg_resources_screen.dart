import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../models/resource.dart';
import '../../provider/api_providers.dart';
import 'resource_detail_screen.dart';

// Create a simple provider for resources by type similar to allEventsProvider
final resourcesByTypeProvider = FutureProvider.autoDispose.family<List<Resource>, String?>((ref, type) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getResources(
      type: type,
      perPage: 50,
    );
    return response.data;
  } catch (e) {
    // If authentication fails, return empty response
    if (e.toString().contains('unauthenticated') || e.toString().contains('401')) {
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
      appBar: AppBar(
        title: const Text('Resources'),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              dividerHeight: 0,
              controller: _tabController,
              labelColor: AppTheme.primaryGold,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppTheme.primaryGold.withOpacity(0.1),
                border: Border.all(
                  color: AppTheme.primaryGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              labelStyle: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.library_books, size: 16),
                      SizedBox(height: 2),
                      Text('All', textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Tab(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.menu_book, size: 16),
                      SizedBox(height: 2),
                      Text('E-Books', textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Tab(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.headphones, size: 16),
                      SizedBox(height: 2),
                      Text('Audio', textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Tab(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.play_circle, size: 16),
                      SizedBox(height: 2),
                      Text('Sermons', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: const [
          ResourcesTab(type: null),
          ResourcesTab(type: 'ebook'),
          ResourcesTab(type: 'audiobook'),
          ResourcesTab(type: 'sermon'),
        ],
      ),
    );
  }
}

class ResourcesTab extends ConsumerWidget {
  final String? type;

  const ResourcesTab({super.key, this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(resourcesByTypeProvider(type));

    return resourcesAsync.when(
      data: (resources) => _buildResourcesList(context, resources),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load resources',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.refresh(resourcesByTypeProvider(type)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesList(BuildContext context, List<Resource> resources) {
    if (resources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No resources available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return ResourceCard(resource: resource);
      },
    );
  }
}

class ResourceCard extends StatelessWidget {
  final Resource resource;

  const ResourceCard({super.key, required this.resource});

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
        return Colors.blue;
      case 'audiobook':
        return Colors.green;
      case 'sermon':
        return Colors.red;
      default:
        return Colors.grey;
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResourceDetailScreen(resourceId: resource.id.toString()),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getResourceColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getResourceIcon(),
                  color: _getResourceColor(),
                  size: 30,
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
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resource.displayDescription,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          size: 16,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          resource.displayLanguage,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
