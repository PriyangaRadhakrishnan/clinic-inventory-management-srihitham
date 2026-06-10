import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/patient_model.dart';
import '../providers/patient_provider.dart';
import 'add_patient_view.dart';
import 'edit_patient_view.dart';
import 'patient_details_view.dart';

class PatientsView extends StatefulWidget {
  const PatientsView({super.key});

  @override
  State<PatientsView> createState() => _PatientsViewState();
}

class _PatientsViewState extends State<PatientsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= AppDimensions.tabletBreakPoint;
    final isTablet = size.width >= AppDimensions.mobileBreakPoint && size.width < AppDimensions.tabletBreakPoint;
    final isWide = isDesktop || isTablet;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: !isWide
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPatientView()),
                );
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header / Search area
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(AppDimensions.spaceM),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => patientProvider.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'Search by ID, Name or Phone...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  patientProvider.setSearchQuery('');
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spaceS,
                          horizontal: AppDimensions.spaceM,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          borderSide: const BorderSide(color: AppColors.border, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          borderSide: const BorderSide(color: AppColors.border, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isWide) ...[
                  const SizedBox(width: AppDimensions.spaceM),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddPatientView()),
                      );
                    },
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text('Add Patient'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // Error block
          if (patientProvider.error != null)
            Container(
              color: AppColors.errorContainer,
              padding: const EdgeInsets.all(AppDimensions.spaceM),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(width: AppDimensions.spaceS),
                  Expanded(
                    child: Text(
                      patientProvider.error!,
                      style: const TextStyle(color: AppColors.onErrorContainer),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.error),
                    onPressed: () => patientProvider.clearError(),
                  ),
                ],
              ),
            ),

          // Main content
          Expanded(
            child: patientProvider.isLoading && patientProvider.filteredPatients.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : patientProvider.filteredPatients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: 64,
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                            const SizedBox(height: AppDimensions.spaceM),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'No search results found'
                                  : 'No patients registered yet',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                      )
                    : isWide
                        ? _buildDesktopTable(patientProvider.filteredPatients)
                        : _buildMobileCards(patientProvider.filteredPatients),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(List<PatientModel> list) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 320, // offset navigation drawer
          ),
          padding: const EdgeInsets.all(AppDimensions.spaceM),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(AppColors.background),
                dataRowMinHeight: 56.0,
                dataRowMaxHeight: 64.0,
                horizontalMargin: AppDimensions.spaceM,
                columnSpacing: AppDimensions.spaceM,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Patient ID',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Phone',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Gender',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Age',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Reg. Date',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
                rows: list.map((patient) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          patient.patientId,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ),
                      DataCell(Text(patient.name)),
                      DataCell(Text(patient.phone)),
                      DataCell(Text(patient.gender)),
                      DataCell(Text('${patient.age} yrs')),
                      DataCell(Text(DateFormat('dd-MMM-yyyy').format(patient.registrationDate))),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'View Details',
                              icon: const Icon(Icons.visibility_outlined, color: AppColors.primary),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PatientDetailsView(patient: patient),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              tooltip: 'Edit Profile',
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditPatientView(patient: patient),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileCards(List<PatientModel> list) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final patient = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientDetailsView(patient: patient),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        patient.patientId,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        DateFormat('dd-MMM-yyyy').format(patient.registrationDate),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: AppColors.onSurfaceVariant.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXS),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 14, color: AppColors.outline),
                      const SizedBox(width: AppDimensions.spaceXS),
                      Text(patient.phone),
                      const Spacer(),
                      Text(
                        '${patient.gender} • ${patient.age} yrs',
                        style: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.8)),
                      ),
                    ],
                  ),
                  const Divider(height: AppDimensions.spaceM, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit'),
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
                      FilledButton.icon(
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: const Text('View'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PatientDetailsView(patient: patient),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
