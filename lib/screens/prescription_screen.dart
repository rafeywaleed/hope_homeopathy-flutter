// prescriptions_screen.dart
import 'package:clinic_app/models/patient.dart';
import 'package:clinic_app/widgets/patient_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({Key? key}) : super(key: key);

  @override
  PrescriptionsScreenState createState() => PrescriptionsScreenState();
}

class PrescriptionsScreenState extends State<PrescriptionsScreen> {
  Patient? _selectedPatient;
  bool _showPatientSelection = true;

  // Sample prescription data
  final List<Map<String, dynamic>> _prescriptions = [
    {
      'id': 'RX-001',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'doctorName': 'Dr. Saad',
      'doctorSpecialization': 'Senior Physiotherapist',
      'diagnosis': 'Lower Back Pain',
      'medications': [
        {
          'name': 'Ibuprofen',
          'dosage': '400mg',
          'frequency': '3 times a day',
          'duration': '5 days'
        },
        {
          'name': 'Muscle Relaxant',
          'dosage': '10mg',
          'frequency': '2 times a day',
          'duration': '7 days'
        },
      ],
      'instructions': 'Take after meals. Avoid driving after medication.',
      'status': 'active',
    },
    {
      'id': 'RX-002',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'doctorName': 'Dr. Saad',
      'doctorSpecialization': 'Senior Physiotherapist',
      'diagnosis': 'Neck Sprain',
      'medications': [
        {
          'name': 'Paracetamol',
          'dosage': '500mg',
          'frequency': 'As needed',
          'duration': '3 days'
        },
      ],
      'instructions': 'Apply cold compress. Rest for 48 hours.',
      'status': 'completed',
    },
    {
      'id': 'RX-003',
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'doctorName': 'Dr. Saad',
      'doctorSpecialization': 'Senior Physiotherapist',
      'diagnosis': 'Knee Arthritis',
      'medications': [
        {
          'name': 'Glucosamine',
          'dosage': '1500mg',
          'frequency': 'Once daily',
          'duration': '30 days'
        },
        {
          'name': 'Pain Relief Gel',
          'dosage': 'Apply thin layer',
          'frequency': '3 times a day',
          'duration': '15 days'
        },
      ],
      'instructions': 'Continue physiotherapy exercises. Follow up in 4 weeks.',
      'status': 'active',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Show patient selection when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && PatientSelectionService().patients.isNotEmpty) {
        _showPatientSelectionSheet();
      }
    });
  }

  void _showPatientSelectionSheet() {
    setState(() {
      _showPatientSelection = true;
    });

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
        title: 'Select Patient',
        description: 'Choose a patient to view prescriptions',
        onPatientSelected: (patient) {
          setState(() {
            _selectedPatient = patient;
            _showPatientSelection = false;
          });
        },
        showAddPatientOption: true,
      ),
    );
  }

  void _changePatient() {
    _showPatientSelectionSheet();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return const Color(0xFF4CAF50);
      case 'completed':
        return const Color(0xFF2196F3);
      case 'expired':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'expired':
        return 'Expired';
      default:
        return 'Unknown';
    }
  }

  Widget _buildPatientHeader() {
    if (_selectedPatient == null) return const SizedBox();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[100]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2196F3).withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                _selectedPatient!.firstName[0],
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2196F3),
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedPatient!.fullName,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
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
                      '${_selectedPatient!.age} years • ${_selectedPatient!.gender}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                if (_selectedPatient!.bloodGroup != null) ...[
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Icon(
                        Iconsax.heart,
                        size: 3.5.w,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Blood Group: ${_selectedPatient!.bloodGroup}',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: _changePatient,
            icon: Icon(
              Iconsax.refresh_circle,
              size: 6.w,
              color: const Color(0xFF2196F3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(Map<String, dynamic> prescription) {
    final date = prescription['date'] as DateTime;
    final status = prescription['status'] as String;
    final statusColor = _getStatusColor(status);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey[100]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    prescription['id'],
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 0.8.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    _getStatusText(status),
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.5.h),
            Row(
              children: [
                Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                  ),
                  child: Center(
                    child: Icon(
                      Iconsax.profile_circle,
                      color: const Color(0xFF2196F3),
                      size: 7.w,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prescription['doctorName'],
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        prescription['doctorSpecialization'],
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        DateFormat('dd MMM yyyy').format(date),
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.5.h),
            Text(
              'Diagnosis',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                prescription['diagnosis'],
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 2.5.h),
            Text(
              'Medications',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 1.h),
            ...(prescription['medications'] as List).map((medication) {
              return Container(
                margin: EdgeInsets.only(bottom: 1.5.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[100]!,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication['name'],
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        _buildMedicationDetail(
                          icon: Icons.medication_outlined,
                          text: medication['dosage'],
                        ),
                        SizedBox(width: 3.w),
                        _buildMedicationDetail(
                          icon: Iconsax.clock,
                          text: medication['frequency'],
                        ),
                        SizedBox(width: 3.w),
                        _buildMedicationDetail(
                          icon: Iconsax.calendar_1,
                          text: medication['duration'],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 2.5.h),
            Text(
              'Instructions',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange[100]!,
                  width: 1.5,
                ),
              ),
              child: Text(
                prescription['instructions'],
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange[800],
                ),
              ),
            ),
            SizedBox(height: 2.5.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.document_download, size: 6.w),
                    SizedBox(width: 3.w),
                    Flexible(
                      child: Text(
                        'Download Prescription',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildMedicationDetail({
    required IconData icon,
    required String text,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 4.w,
              color: Colors.grey[600],
            ),
            SizedBox(height: 0.5.h),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: Center(
              child: Icon(
                Iconsax.note_remove,
                size: 12.w,
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'No Prescriptions',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 1.5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'No prescriptions found for the selected patient',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2196F3).withOpacity(0.3),
            ),
            child: Center(
              child: Icon(
                Iconsax.user_search,
                size: 12.w,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Select Patient',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'Please select a patient to view their prescriptions',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: 70.w,
            child: ElevatedButton(
              onPressed: _showPatientSelectionSheet,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: const Color(0xFF2196F3),
              ),
              child: Text(
                'Select Patient',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(179, 243, 243, 243),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Prescriptions",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  if (_selectedPatient != null)
                    IconButton(
                      onPressed: _showPatientSelectionSheet,
                      icon: Icon(
                        Iconsax.user_add,
                        size: 6.w,
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                ],
              ),
            ),
            // Patient Header
            if (_selectedPatient != null) _buildPatientHeader(),
            // Content
            Expanded(
              child: _selectedPatient == null
                  ? _buildInitialState()
                  : _prescriptions.isEmpty
                      ? _buildEmptyState()
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              ..._prescriptions
                                  .map((p) => _buildPrescriptionCard(p)),
                              SizedBox(height: 4.h),
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
