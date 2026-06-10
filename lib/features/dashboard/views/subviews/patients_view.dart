import 'package:flutter/material.dart';
import 'module_placeholder_view.dart';

class PatientsView extends StatelessWidget {
  const PatientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderView(
      title: 'Patients Registry',
      description: 'Centralized registry to manage clinical profiles, historical medical charts, appointments, and diagnostic records.',
      icon: Icons.person_outline_rounded,
      futureSubModules: [
        'Patient Enrollment & Search',
        'Electronic Health Records (EHR)',
        'Clinical Visit History (Consultations)',
        'Active Prescriptions Tracker',
        'Vitals & Diagnostic Reports Logger'
      ],
    );
  }
}
