import 'package:flutter/material.dart';
import 'module_placeholder_view.dart';

class BillingView extends StatelessWidget {
  const BillingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderView(
      title: 'Billing & Invoicing',
      description: 'Manage clinic consultations billing, pharmacy invoice generation, discount rates, and receipt summaries.',
      icon: Icons.payments_outlined,
      futureSubModules: [
        'Invoice Generation (Consultations + Drugs)',
        'Payment Options (UPI, Card, Cash, Insurance)',
        'Refunds & Discount Management',
        'Daily Cash Closure Summary',
        'Tax & GST Reports Compilation'
      ],
    );
  }
}
