import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ScrollableHeaderTabs extends StatelessWidget {
  final Widget heroSection;
  final TabController tabController;
  final List<Widget> tabs;
  final Widget body;
  final EdgeInsets? tabMargin;
  final EdgeInsets? tabPadding;

  const ScrollableHeaderTabs({
    super.key,
    required this.heroSection,
    required this.tabController,
    required this.tabs,
    required this.body,
    this.tabMargin,
    this.tabPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Hero section that scrolls normally
            SliverToBoxAdapter(
              child: heroSection,
            ),
            // Tab bar that sticks to top when scrolled
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabController: tabController,
                tabs: tabs,
                margin: tabMargin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: tabPadding ?? const EdgeInsets.symmetric(vertical: 3),
              ),
            ),
            // Body content
            SliverFillRemaining(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<Widget> tabs;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const _TabBarDelegate({
    required this.tabController,
    required this.tabs,
    required this.margin,
    required this.padding,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.richBlack, // Background color to avoid transparency issues
      padding: margin,
      child: Container(
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
          indicatorSize: TabBarIndicatorSize.label,
          dividerHeight: 0,
          indicator: BoxDecoration(
            color: AppTheme.primaryGold,
            borderRadius: BorderRadius.circular(20),
          ),
          indicatorPadding: padding,
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
      ),
    );
  }

  @override
  double get maxExtent => 76.0; // Height needed for the tab bar container

  @override
  double get minExtent => 76.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}