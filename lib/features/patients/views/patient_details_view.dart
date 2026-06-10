import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/patient_model.dart';
import 'edit_patient_view.dart';

class PatientDetailsView extends StatelessWidget {
  final PatientModel patient;
  const PatientDetailsView({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= AppDimensions.tabletBreakPoint;
    final isTablet = size.width >= AppDimensions.mobileBreakPoint && size.width < AppDimensions.tabletBreakPoint;
    final isWide = isDesktop || isTablet;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          patient.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Edit Profile',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditPatientView(patient: patient),
                ),
              );
            },
          ),
          const SizedBox(width: AppDimensions.spaceS),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceM),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Patient Main Profile Card
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    side: const BorderSide(color: AppColors.border, width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isWide ? AppDimensions.spaceXL : AppDimensions.spaceM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: isWide ? 36.0 : 28.0,
                              backgroundColor: AppColors.primaryContainer,
                              child: Text(
                                patient.name.isNotEmpty ? patient.name[0].toUpperCase() : 'P',
                                style: TextStyle(
                                  fontSize: isWide ? 28.0 : 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spaceM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          patient.name,
                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppDimensions.spaceXS),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Text(
                                      patient.patientId,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                          child: Divider(color: AppColors.border),
                        ),
                        
                        // Detail Fields Grid
                        isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildDetailsColumn1()),
                                  const SizedBox(width: AppDimensions.spaceXL),
                                  Expanded(child: _buildDetailsColumn2()),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildDetailsColumn1(),
                                  const SizedBox(height: AppDimensions.spaceM),
                                  _buildDetailsColumn2(),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),

                // Future Modules Expansion Sections
                _buildExpansionCard(
                  title: 'Visit History',
                  subtitle: 'Historical clinical notes, diagnostics & symptom evaluations',
                  icon: Icons.assignment_outlined,
                  placeholderDesc: 'No visits recorded',
                ),
                const SizedBox(height: AppDimensions.spaceS),
                _buildExpansionCard(
                  title: 'Prescription History',
                  subtitle: 'Active and historical prescriptions list',
                  icon: Icons.medication_outlined,
                  placeholderDesc: 'No prescription records found for this patient.',
                ),
                const SizedBox(height: AppDimensions.spaceS),
                _buildExpansionCard(
                  title: 'Billing History',
                  subtitle: 'Consultation fees, pharmacy bills and payments records',
                  icon: Icons.receipt_long_outlined,
                  placeholderDesc: 'No billing records exist for this patient.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsColumn1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem(Icons.phone_outlined, 'Phone Number', patient.phone),
        const SizedBox(height: AppDimensions.spaceM),
        _buildInfoItem(Icons.wc_outlined, 'Gender', patient.gender.trim().isEmpty ? 'Not Provided' : patient.gender),
        const SizedBox(height: AppDimensions.spaceM),
        _buildInfoItem(Icons.cake_outlined, 'Date of Birth', DateFormat('dd-MMM-yyyy').format(patient.dateOfBirth)),
      ],
    );
  }

  Widget _buildDetailsColumn2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem(Icons.perm_identity_outlined, 'Age', '${patient.age} Years'),
        const SizedBox(height: AppDimensions.spaceM),
        _buildInfoItem(Icons.location_on_outlined, 'Address', patient.address.trim().isEmpty ? 'Not Provided' : patient.address),
        const SizedBox(height: AppDimensions.spaceM),
        _buildInfoItem(Icons.calendar_month_outlined, 'Registration Date', DateFormat('dd-MMM-yyyy HH:mm').format(patient.registrationDate)),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceS),
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12.0, color: AppColors.outline, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2.0),
              Text(
                value,
                style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.onBackground),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String placeholderDesc,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(AppDimensions.spaceS),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 11.0, color: AppColors.outline),
          ),
          children: [
            const Divider(height: 1.0, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceXL),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: 36,
                      color: AppColors.outline.withOpacity(0.3),
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    Text(
                      placeholderDesc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: AppColors.outline,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
