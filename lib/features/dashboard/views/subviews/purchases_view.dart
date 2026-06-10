import 'package:flutter/material.dart';
import 'module_placeholder_view.dart';

class PurchasesView extends StatelessWidget {
  const PurchasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderView(
      title: 'Purchase Orders',
      description: 'Procurement manager for stock refills, vendor transactions, purchase histories, and incoming shipments verification.',
      icon: Icons.local_shipping_outlined,
      futureSubModules: [
        'Purchase Requisition & Approvals',
        'Vendor Catalog & Price Mapping',
        'Receipt verification (Goods Received Note - GRN)',
        'Defective/Damage Return Logs',
        'Accounts Payable Integration'
      ],
    );
  }
}
