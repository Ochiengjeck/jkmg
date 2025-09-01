import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SimpleHeaderTabs extends StatelessWidget {
  final Widget heroSection;
  final TabController tabController;
  final List<Widget> tabs;
  final List<Widget> tabViews;
  final EdgeInsets? tabMargin;
  final EdgeInsets? tabPadding;

  const SimpleHeaderTabs({
    super.key,
    required this.heroSection,
    required this.tabController,
    required this.tabs,
    required this.tabViews,
    this.tabMargin,
    this.tabPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Hero section that scrolls normally
              SliverToBoxAdapter(
                child: heroSection,
              ),
              // Tab bar that sticks when scrolled
              SliverAppBar(
                pinned: true,
                backgroundColor: AppTheme.richBlack,
                automaticallyImplyLeading: false,
                toolbarHeight: 76.0,
                flexibleSpace: Container(
                  color: AppTheme.richBlack,
                  child: _buildTabBar(),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: tabViews,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final margin = tabMargin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    final padding = tabPadding ?? const EdgeInsets.symmetric(vertical: 3);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.white60,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0,
        indicator: BoxDecoration(
          color: AppTheme.primaryGold,
          borderRadius: BorderRadius.circular(20),
        ),
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        tabs: tabs,
      ),
    );
  }
}