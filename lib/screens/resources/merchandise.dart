import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/widgets/common_widgets.dart';

import '../../utils/app_theme.dart';

class MerchandiseTab extends ConsumerWidget {
  const MerchandiseTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeSection(
            title: 'JKMG Merchandise',
            subtitle:
                'Explore a range of JKMG-branded products—from hoodies and sweaters to mugs and more. All items support the ministry and spread the Kingdom message.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _merchandiseItems.length,
              itemBuilder: (context, index) {
                final item = _merchandiseItems[index];
                return _buildMerchandiseCard(context, item);
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _viewFullCollection(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('View Full Collection'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchandiseCard(BuildContext context, MerchandiseItem item) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Icon(item.icon, size: 48, color: AppTheme.deepGold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${item.price}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.deepGold,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _viewItem(context, item),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      child: const Text('View'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewItem(BuildContext context, MerchandiseItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 64, color: AppTheme.deepGold),
            const SizedBox(height: 16),
            Text('Price: \$${item.price}'),
            const SizedBox(height: 8),
            Text(item.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _orderItem(context, item);
            },
            child: const Text('Order Now'),
          ),
        ],
      ),
    );
  }

  void _orderItem(BuildContext context, MerchandiseItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redirecting to order "${item.name}"...'),
        backgroundColor: AppTheme.primaryGold,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewFullCollection(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening full merchandise collection...'),
        backgroundColor: AppTheme.primaryGold,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static const List<MerchandiseItem> _merchandiseItems = [
    MerchandiseItem(
      name: 'JKMG Hoodie',
      price: 45,
      description: 'Premium quality hoodie with JKMG logo',
      icon: Icons.checkroom,
    ),
    MerchandiseItem(
      name: 'Faith Mug',
      price: 15,
      description: 'Inspirational mug with Kingdom message',
      icon: Icons.coffee,
    ),
    MerchandiseItem(
      name: 'Prayer Journal',
      price: 25,
      description: 'Beautiful journal for recording prayers',
      icon: Icons.book,
    ),
    MerchandiseItem(
      name: 'Kingdom Cap',
      price: 20,
      description: 'Stylish cap with JKMG branding',
      icon: Icons.sports_baseball,
    ),
    MerchandiseItem(
      name: 'Tote Bag',
      price: 18,
      description: 'Eco-friendly tote with ministry logo',
      icon: Icons.shopping_bag,
    ),
    MerchandiseItem(
      name: 'Car Decal',
      price: 8,
      description: 'Weather-resistant JKMG car decal',
      icon: Icons.directions_car,
    ),
  ];
}

class MerchandiseItem {
  final String name;
  final int price;
  final String description;
  final IconData icon;

  const MerchandiseItem({
    required this.name,
    required this.price,
    required this.description,
    required this.icon,
  });
}
