import 'package:clinic_app/models/patient.dart';
import 'package:clinic_app/screens/appointment_screen.dart';
import 'package:clinic_app/widgets/patient_creation_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class PatientSelectionSheet extends StatelessWidget {
  final String title;
  final String description;
  final Function(Patient) onPatientSelected;
  final bool showAddPatientOption;
  final VoidCallback? onAddPatient;

  const PatientSelectionSheet({
    Key? key,
    required this.title,
    required this.description,
    required this.onPatientSelected,
    this.showAddPatientOption = true,
    this.onAddPatient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final patientService = PatientSelectionService();

    return Container(
      padding: EdgeInsets.only(
        left: 5.w,
        right: 5.w,
        top: 3.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 3.h,
      ),
      height: 80.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
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
            description,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 3.h),

          // Add New Patient Button (optional)
          if (showAddPatientOption) ...[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF2196F3).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: TextButton.icon(
                onPressed: onAddPatient ??
                    () {
                      Navigator.pop(context);
                      _showAddPatientSheet(context);
                    },
                icon: Icon(
                  Iconsax.add_circle,
                  color: const Color(0xFF2196F3),
                  size: 5.w,
                ),
                label: Text(
                  'Add New Patient',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],

          Text(
            'Linked Patients',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 2.h),

          // Patients List
          Expanded(
            child: patientService.patients.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: patientService.patients.length,
                    itemBuilder: (context, index) {
                      final patient = patientService.patients[index];
                      return _buildPatientTile(context, patient);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientTile(BuildContext context, Patient patient) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[100]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          onPatientSelected(patient);
          Navigator.pop(context);
        },
        contentPadding: EdgeInsets.all(3.w),
        leading: Container(
          width: 14.w,
          height: 14.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2196F3).withOpacity(0.1),
          ),
          child: Center(
            child: Text(
              patient.firstName[0],
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2196F3),
              ),
            ),
          ),
        ),
        title: Text(
          patient.fullName,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Icon(
                  Iconsax.calendar,
                  size: 3.5.w,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 1.w),
                Text(
                  '${patient.age} years • ${patient.gender}',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            // Row(
            //   children: [
            //     Icon(
            //       Iconsax.call,
            //       size: 3.5.w,
            //       color: Colors.grey[500],
            //     ),
            //     SizedBox(width: 1.w),
            //     Text(
            //       patient.mobileNumber,
            //       style: GoogleFonts.inter(
            //         fontSize: 11.sp,
            //         color: Colors.grey[600],
            //       ),
            //     ),
            //   ],
            // ),
            //
            //   ],
          ],
        ),
        trailing: Icon(
          Iconsax.arrow_right_3,
          size: 5.w,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.profile_remove,
            size: 15.w,
            color: Colors.grey[300],
          ),
          SizedBox(height: 2.h),
          Text(
            'No Patients Found',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add a patient to get started',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPatientSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) => AddPatientSheet(
        onPatientAdded: (patient) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Patient added successfully',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          // Reopen select patient sheet
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              backgroundColor: Colors.white,
              builder: (context) => PatientSelectionSheet(
                title: title,
                description: description,
                onPatientSelected: onPatientSelected,
                showAddPatientOption: showAddPatientOption,
                onAddPatient: onAddPatient,
              ),
            );
          });
        },
      ),
    );
  }
}
