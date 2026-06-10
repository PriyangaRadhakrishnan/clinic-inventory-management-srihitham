import 'package:flutter/material.dart';
import 'module_placeholder_view.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderView(
      title: 'Medicine Inventory',
      description: 'Manage clinic drugs, medical supplies, reorder thresholds, and distributor logs.',
      icon: Icons.medication_liquid_rounded,
      futureSubModules: [
        'Medicine Catalog & Search',
        'Batch & Expiry Date Management',
        'Stock Level Auditing (Auto low-stock notifications)',
        'Supplier / Vendor Profiles',
        'Inventory Dispatch Logs (To dispensary)'
      ],
    );
  }
}
