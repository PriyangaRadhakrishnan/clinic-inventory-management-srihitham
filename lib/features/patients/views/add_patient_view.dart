import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../providers/patient_provider.dart';

class AddPatientView extends StatefulWidget {
  const AddPatientView({super.key});

  @override
  State<AddPatientView> createState() => _AddPatientViewState();
}

class _AddPatientViewState extends State<AddPatientView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  DateTime? _selectedDob;
  String? _selectedGender;
  bool _submitting = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

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
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
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
    if (_selectedDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Date of Birth')),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    final patientProvider = Provider.of<PatientProvider>(context, listen: false);

    // Calculate age based on Date of Birth
    final age = DateTime.now().year - _selectedDob!.year;

    final result = await patientProvider.addPatient(
      name: _nameController.text.trim(),
      age: age,
      gender: _selectedGender ?? '',
      phone: _phoneController.text.trim(),
      dateOfBirth: _selectedDob!,
      address: _addressController.text.trim(),
    );

    setState(() {
      _submitting = false;
    });

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient registered successfully with ID: $result'),
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
        title: const Text(
          'Register New Patient',
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Patient Enrollment',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      const Text(
                        'Ensure all details match official government IDs where possible.',
                        style: TextStyle(fontSize: 12.0, color: AppColors.outline),
                      ),
                      const SizedBox(height: AppDimensions.spaceL),

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
                                : const Text('Register Patient'),
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
        labelText: 'Select Gender (Optional)',
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
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Residential Address (Optional)',
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 36),
          child: Icon(Icons.location_on_outlined, color: AppColors.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
      ),
    );
  }
}
