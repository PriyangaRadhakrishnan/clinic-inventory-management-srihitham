import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/visit_model.dart';

class VisitDetailsView extends StatelessWidget {
  final VisitModel visit;

  const VisitDetailsView({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= AppDimensions.tabletBreakPoint;
    final isTablet = size.width >= AppDimensions.mobileBreakPoint && size.width < AppDimensions.tabletBreakPoint;
    final isWide = isDesktop || isTablet;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Visit Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0, color: AppColors.border),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceM),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isWide ? 800 : 500,
            ),
            child: Card(
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
                    Text(
                      'Clinical Visit Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    _buildDetailItem(
                      icon: Icons.person_outline,
                      label: 'Patient ID',
                      value: visit.patientId,
                    ),
                    const Divider(height: AppDimensions.spaceXL, color: AppColors.border),
                    _buildDetailItem(
                      icon: Icons.event_note_outlined,
                      label: 'Visit ID',
                      value: visit.visitId,
                    ),
                    const Divider(height: AppDimensions.spaceXL, color: AppColors.border),
                    _buildDetailItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Visit Date',
                      value: DateFormat('dd-MMM-yyyy').format(visit.visitDate),
                    ),
                    const Divider(height: AppDimensions.spaceXL, color: AppColors.border),
                    _buildDetailItem(
                      icon: Icons.bubble_chart_outlined,
                      label: 'Symptoms',
                      value: visit.symptoms.trim().isEmpty ? 'None recorded' : visit.symptoms,
                    ),
                    const Divider(height: AppDimensions.spaceXL, color: AppColors.border),
                    _buildDetailItem(
                      icon: Icons.healing_outlined,
                      label: 'Diagnosis',
                      value: visit.diagnosis.trim().isEmpty ? 'None recorded' : visit.diagnosis,
                    ),
                    const Divider(height: AppDimensions.spaceXL, color: AppColors.border),
                    _buildDetailItem(
                      icon: Icons.description_outlined,
                      label: 'Doctor Notes',
                      value: visit.doctorNotes.trim().isEmpty ? 'None recorded' : visit.doctorNotes,
                    ),
                    const Divider(height: AppDimensions.spaceXL, color: AppColors.border),
                    _buildDetailItem(
                      icon: Icons.update_outlined,
                      label: 'Follow-up Date',
                      value: visit.followUpDate != null
                          ? DateFormat('dd-MMM-yyyy').format(visit.followUpDate!)
                          : 'None scheduled',
                    ),
                    const Divider(height: AppDimensions.spaceXL, color: AppColors.border),
                    Row(
                      children: [
                        const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: AppDimensions.spaceM),
                        Text(
                          'Prescription History',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.spaceM),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.outline, size: 18),
                          SizedBox(width: AppDimensions.spaceS),
                          Text(
                            'No prescriptions recorded',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: AppColors.outline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
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
              const SizedBox(height: 4.0),
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
}
