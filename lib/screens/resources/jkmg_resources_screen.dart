import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'audio_video.dart';
import 'digital_materials.dart';
import 'merchandise.dart';

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
    _tabController = TabController(length: 3, vsync: this);
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
              labelColor: Colors.white,
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
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_rounded, size: 18),
                      const SizedBox(height: 3),
                      Text(
                        'Digital\nMaterials',
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.1),
                      ),
                    ],
                  ),
                ),
                Tab(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam_rounded, size: 18),
                      const SizedBox(height: 3),
                      Text('Audio/Video', textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Tab(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.storefront_rounded, size: 18),
                      const SizedBox(height: 3),
                      Text('Merchandise', textAlign: TextAlign.center),
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
          DigitalMaterialsTab(),
          AudioVideoTab(),
          MerchandiseTab(),
        ],
      ),
    );
  }
}
