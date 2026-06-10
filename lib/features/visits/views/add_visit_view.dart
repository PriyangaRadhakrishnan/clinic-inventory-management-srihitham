import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../patients/models/patient_model.dart';
import '../models/visit_model.dart';
import '../providers/visit_provider.dart';

class AddVisitView extends StatefulWidget {
  final PatientModel patient;
  const AddVisitView({super.key, required this.patient});

  @override
  State<AddVisitView> createState() => _AddVisitViewState();
}

class _AddVisitViewState extends State<AddVisitView> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _doctorNotesController = TextEditingController();

  DateTime _visitDate = DateTime.now();
  DateTime? _followUpDate;
  bool _submitting = false;

  @override
  void dispose() {
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _doctorNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectVisitDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _visitDate) {
      setState(() {
        _visitDate = picked;
      });
    }
  }

  Future<void> _selectFollowUpDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _followUpDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _followUpDate) {
      setState(() {
        _followUpDate = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
    });

    final visitProvider = Provider.of<VisitProvider>(context, listen: false);

    final newVisit = VisitModel(
      id: '',
      visitId: '',
      patientId: widget.patient.patientId,
      visitDate: _visitDate,
      symptoms: _symptomsController.text.trim(),
      diagnosis: _diagnosisController.text.trim(),
      doctorNotes: _doctorNotesController.text.trim(),
      followUpDate: _followUpDate,
      createdAt: DateTime.now(),
    );

    final resultId = await visitProvider.addVisit(newVisit);

    setState(() {
      _submitting = false;
    });

    if (resultId != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Visit recorded successfully with ID: $resultId'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    } else if (visitProvider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(visitProvider.error!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

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
          'New Visit: ${widget.patient.name}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Record Patient Visit',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        'Patient ID: ${widget.patient.patientId}',
                        style: const TextStyle(fontSize: 12.0, color: AppColors.outline),
                      ),
                      const SizedBox(height: AppDimensions.spaceL),

                      // Dates Row
                      if (isWide) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildVisitDateField()),
                            const SizedBox(width: AppDimensions.spaceM),
                            Expanded(child: _buildFollowUpDateField()),
                          ],
                        ),
                      ] else ...[
                        _buildVisitDateField(),
                        const SizedBox(height: AppDimensions.spaceM),
                        _buildFollowUpDateField(),
                      ],
                      const SizedBox(height: AppDimensions.spaceM),

                      // Symptoms
                      _buildSymptomsField(),
                      const SizedBox(height: AppDimensions.spaceM),

                      // Diagnosis
                      _buildDiagnosisField(),
                      const SizedBox(height: AppDimensions.spaceM),

                      // Prescription Notes
                      _buildDoctorNotesField(),
                      const SizedBox(height: AppDimensions.spaceXL),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: _submitting ? null : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.spaceM,
                                horizontal: AppDimensions.spaceL,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          FilledButton(
                            onPressed: _submitting ? null : _handleSubmit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.spaceM,
                                horizontal: AppDimensions.spaceL,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              ),
                            ),
                            child: _submitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('Save Visit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisitDateField() {
    return InkWell(
      onTap: () => _selectVisitDate(context),
      child: IgnorePointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Visit Date',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
          ),
          controller: TextEditingController(
            text: DateFormat('dd-MMM-yyyy').format(_visitDate),
          ),
          validator: (_) {
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildFollowUpDateField() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectFollowUpDate(context),
            child: IgnorePointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Follow-up Date (Optional)',
                  hintText: 'Select date...',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: const Icon(Icons.event_note_outlined, color: AppColors.primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
                ),
                controller: TextEditingController(
                  text: _followUpDate == null ? '' : DateFormat('dd-MMM-yyyy').format(_followUpDate!),
                ),
              ),
            ),
          ),
        ),
        if (_followUpDate != null) ...[
          const SizedBox(width: AppDimensions.spaceXS),
          IconButton(
            tooltip: 'Clear Date',
            icon: const Icon(Icons.clear, color: AppColors.outline),
            onPressed: () {
              setState(() {
                _followUpDate = null;
              });
            },
          ),
        ]
      ],
    );
  }

  Widget _buildSymptomsField() {
    return TextFormField(
      controller: _symptomsController,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Symptoms (Optional)',
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 36),
          child: Icon(Icons.sick_outlined, color: AppColors.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
      ),
    );
  }

  Widget _buildDiagnosisField() {
    return TextFormField(
      controller: _diagnosisController,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Diagnosis (Optional)',
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 36),
          child: Icon(Icons.troubleshoot_outlined, color: AppColors.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
      ),
    );
  }

  Widget _buildDoctorNotesField() {
    return TextFormField(
      controller: _doctorNotesController,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Doctor Notes (Optional)',
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 36),
          child: Icon(Icons.note_alt_outlined, color: AppColors.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
      ),
    );
  }
}
