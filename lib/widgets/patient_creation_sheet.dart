import 'package:clinic_app/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AddPatientSheet extends StatefulWidget {
  final Function(Patient) onPatientAdded;

  const AddPatientSheet({
    Key? key,
    required this.onPatientAdded,
  }) : super(key: key);

  @override
  _AddPatientSheetState createState() => _AddPatientSheetState();
}

class _AddPatientSheetState extends State<AddPatientSheet> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _abhaController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  String? _selectedBloodGroup = 'Select Blood Group';
  final String _userMobile = '9876543210';

  final List<String> _bloodGroups = [
    'Select Blood Group',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_updateFullNamePreview);
    _lastNameController.addListener(_updateFullNamePreview);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _abhaController.dispose();
    super.dispose();
  }

  void _updateFullNamePreview() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 5.w,
        right: 5.w,
        top: 3.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 3.h,
      ),
      height: 90.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add New Patient',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Iconsax.close_circle,
                    size: 6.w,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Fill patient details to add to your profile',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 3.h),

            // First Name
            _buildTextField(
              label: 'First Name *',
              controller: _firstNameController,
              hintText: 'Enter first name',
            ),
            SizedBox(height: 2.h),

            // Last Name
            _buildTextField(
              label: 'Last Name *',
              controller: _lastNameController,
              hintText: 'Enter last name',
            ),
            SizedBox(height: 2.h),

            // Full Name Preview
            if (_firstNameController.text.isNotEmpty ||
                _lastNameController.text.isNotEmpty)
              _buildPreviewContainer(
                icon: Iconsax.profile_circle,
                text:
                    'Full Name: ${_firstNameController.text} ${_lastNameController.text}',
                color: const Color(0xFF2196F3),
              ),
            SizedBox(height: 2.h),

            // Date of Birth
            _buildDatePickerField(),
            SizedBox(height: 2.h),

            // Age Display
            if (_selectedDate != null)
              _buildPreviewContainer(
                icon: Iconsax.calendar_tick,
                text:
                    'Age: ${DateTime.now().difference(_selectedDate!).inDays ~/ 365} years',
                color: const Color(0xFF4CAF50),
              ),
            SizedBox(height: 2.h),

            // Gender Selection
            Text(
              'Gender *',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: _buildGenderOption(
                    icon: Iconsax.man,
                    label: 'Male',
                    isSelected: _selectedGender == 'Male',
                    onTap: () => setState(() => _selectedGender = 'Male'),
                    selectedColor: const Color(0xFF2196F3),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildGenderOption(
                    icon: Iconsax.woman,
                    label: 'Female',
                    isSelected: _selectedGender == 'Female',
                    onTap: () => setState(() => _selectedGender = 'Female'),
                    selectedColor: const Color(0xFFE91E63),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildGenderOption(
                    icon: Iconsax.user,
                    label: 'Other',
                    isSelected: _selectedGender == 'Other',
                    onTap: () => setState(() => _selectedGender = 'Other'),
                    selectedColor: const Color(0xFF9C27B0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Blood Group Dropdown
            Text(
              'Blood Group (Optional)',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedBloodGroup,
                  icon: Icon(
                    Iconsax.arrow_down_1,
                    size: 5.w,
                    color: Colors.grey[500],
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: Colors.black87,
                  ),
                  isExpanded: true,
                  items: _bloodGroups.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          value,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: value == 'Select Blood Group'
                                ? Colors.grey[400]
                                : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBloodGroup = newValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Mobile Number (Non-editable)
            _buildReadOnlyField(
              label: 'Mobile Number',
              value: _userMobile,
              icon: Iconsax.lock,
            ),
            SizedBox(height: 2.h),

            // Email (Optional)
            _buildTextField(
              label: 'Email (Optional)',
              controller: _emailController,
              hintText: 'email@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 2.h),

            // ABHA Address (Optional)
            _buildTextField(
              label: 'ABHA Address (Optional)',
              controller: _abhaController,
              hintText: 'username@abha',
            ),
            SizedBox(height: 4.h),

            // Add Patient Button
            _buildAddButton(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 12.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth *',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: () async {
            final DateTime now = DateTime.now();
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime(
                now.year - 18,
                now.month,
                now.day,
              ),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF667EEA),
                      onPrimary: Colors.white,
                    ),
                    dialogBackgroundColor: Colors.white,
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                _selectedDate = picked;
                _dobController.text = DateFormat('dd-MMM-yyyy').format(picked);
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dobController,
                    enabled: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Select date of birth',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 12.sp,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: Icon(
                    Iconsax.calendar,
                    color: Colors.grey[500],
                    size: 5.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color selectedColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey[200]!,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : Colors.grey[500],
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? selectedColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewContainer({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Icon(
                  icon,
                  color: Colors.grey[400],
                  size: 5.w,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_firstNameController.text.isEmpty ||
              _lastNameController.text.isEmpty ||
              _selectedDate == null ||
              _selectedGender == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please fill all required fields',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
                backgroundColor: Colors.red.withOpacity(0.9),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            return;
          }

          final newPatient = Patient(
            id: 'P${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            dob: _selectedDate!,
            age: DateTime.now().difference(_selectedDate!).inDays ~/ 365,
            gender: _selectedGender!,
            bloodGroup: _selectedBloodGroup != 'Select Blood Group'
                ? _selectedBloodGroup
                : null,
            mobileNumber: _userMobile,
            email:
                _emailController.text.isNotEmpty ? _emailController.text : null,
            abhaAddress:
                _abhaController.text.isNotEmpty ? _abhaController.text : null,
          );

          // Add to shared patient service
          PatientSelectionService().addPatient(newPatient);
          widget.onPatientAdded(newPatient);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        child: Text(
          'Add Patient',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
