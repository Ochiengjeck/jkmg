import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class UnifiedHeaderTabs extends StatefulWidget {
  final Widget heroSection;
  final TabController tabController;
  final List<Widget> tabs;
  final Widget body;
  final EdgeInsets? tabMargin;
  final EdgeInsets? tabPadding;

  const UnifiedHeaderTabs({
    super.key,
    required this.heroSection,
    required this.tabController,
    required this.tabs,
    required this.body,
    this.tabMargin,
    this.tabPadding,
  });

  @override
  State<UnifiedHeaderTabs> createState() => _UnifiedHeaderTabsState();
}

class _UnifiedHeaderTabsState extends State<UnifiedHeaderTabs> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingTabs = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show floating tabs when we've scrolled past the hero section
    final shouldShow = _scrollController.offset > 200; // Adjust threshold as needed
    if (shouldShow != _showFloatingTabs) {
      setState(() {
        _showFloatingTabs = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Main scrollable content with hero section
            Expanded(
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(child: widget.heroSection),
                    SliverToBoxAdapter(child: _buildTabBar()),
                  ];
                },
                body: widget.body,
              ),
            ),
            // Floating tab bar when scrolled
            if (_showFloatingTabs)
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.richBlack,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildTabBar(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final margin = widget.tabMargin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    final padding = widget.tabPadding ?? const EdgeInsets.symmetric(vertical: 3);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: TabBar(
        controller: widget.tabController,
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
        tabs: widget.tabs,
      ),
    );
  }
}