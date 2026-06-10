import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/patient_model.dart';
import '../providers/patient_provider.dart';

class EditPatientView extends StatefulWidget {
  final PatientModel patient;
  const EditPatientView({super.key, required this.patient});

  @override
  State<EditPatientView> createState() => _EditPatientViewState();
}

class _EditPatientViewState extends State<EditPatientView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  DateTime? _selectedDob;
  String? _selectedGender;
  bool _submitting = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.name);
    _phoneController = TextEditingController(text: widget.patient.phone);
    _addressController = TextEditingController(text: widget.patient.address);
    _selectedDob = widget.patient.dateOfBirth;
    _selectedGender = widget.patient.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDob(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
    if (picked != null && picked != _selectedDob) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDob == null) return;
    if (_selectedGender == null) return;

    setState(() {
      _submitting = true;
    });

    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    final age = DateTime.now().year - _selectedDob!.year;

    final updatedPatient = widget.patient.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      dateOfBirth: _selectedDob!,
      gender: _selectedGender!,
      age: age,
    );

    final success = await patientProvider.updatePatient(updatedPatient);

    setState(() {
      _submitting = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient details updated successfully'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    } else if (patientProvider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(patientProvider.error!),
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
          'Edit Profile: ${widget.patient.patientId}',
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
                        'Update Patient Record',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      const Text(
                        'Updates to name or phone will undergo validation checks for duplicate listings.',
                        style: TextStyle(fontSize: 12.0, color: AppColors.outline),
                      ),
                      const SizedBox(height: AppDimensions.spaceL),

                      // Read-only parameters Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildReadOnlyField(
                              label: 'Patient ID',
                              value: widget.patient.patientId,
                              icon: Icons.vpn_key_outlined,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(
                            child: _buildReadOnlyField(
                              label: 'Registration Date',
                              value: DateFormat('dd-MMM-yyyy').format(widget.patient.registrationDate),
                              icon: Icons.today_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceM),

                      // Responsive grid fields
                      if (isWide) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildNameField()),
                            const SizedBox(width: AppDimensions.spaceM),
                            Expanded(child: _buildPhoneField()),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spaceM),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildDobField()),
                            const SizedBox(width: AppDimensions.spaceM),
                            Expanded(child: _buildGenderField()),
                          ],
                        ),
                      ] else ...[
                        _buildNameField(),
                        const SizedBox(height: AppDimensions.spaceM),
                        _buildPhoneField(),
                        const SizedBox(height: AppDimensions.spaceM),
                        _buildDobField(),
                        const SizedBox(height: AppDimensions.spaceM),
                        _buildGenderField(),
                      ],

                      const SizedBox(height: AppDimensions.spaceM),
                      _buildAddressField(),

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
                                : const Text('Save Changes'),
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

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.outline, size: 20),
          const SizedBox(width: AppDimensions.spaceS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppColors.outline, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: AppColors.onBackground, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Icon(Icons.lock_outline, color: AppColors.outline, size: 16),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Patient name is required';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Phone number is required';
        }
        if (value.trim().length < 8) {
          return 'Enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildDobField() {
    return InkWell(
      onTap: () => _selectDob(context),
      child: IgnorePointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            hintText: _selectedDob == null ? 'Select date...' : DateFormat('dd-MMM-yyyy').format(_selectedDob!),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
          ),
          controller: TextEditingController(
            text: _selectedDob == null ? '' : DateFormat('dd-MMM-yyyy').format(_selectedDob!),
          ),
          validator: (_) {
            if (_selectedDob == null) return 'Date of Birth is required';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.wc_outlined, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
      ),
      items: _genderOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      validator: (value) {
        if (value == null) return 'Gender is required';
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Residential Address',
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 36),
          child: Icon(Icons.location_on_outlined, color: AppColors.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Residential address is required';
        }
        return null;
      },
    );
  }
}
