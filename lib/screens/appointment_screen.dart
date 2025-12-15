import 'package:clinic_app/models/patient.dart';
import 'package:clinic_app/widgets/patient_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  AppointmentsScreenState createState() => AppointmentsScreenState();
}

class AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  // List of patients linked to the user's mobile number
  List<Map<String, dynamic>> _patients = [
    {
      'id': 'P001',
      'firstName': 'John',
      'lastName': 'Doe',
      'fullName': 'John Doe',
      'dob': DateTime(1990, 5, 15),
      'age': 34,
      'gender': 'Male',
      'bloodGroup': 'O+',
      'mobileNumber': '9876543210',
      'email': 'johndoe@example.com',
      'abhaAddress': 'john.doe@abha',
    },
    {
      'id': 'P002',
      'firstName': 'Jane',
      'lastName': 'Smith',
      'fullName': 'Jane Smith',
      'dob': DateTime(1985, 8, 22),
      'age': 39,
      'gender': 'Female',
      'bloodGroup': 'A+',
      'mobileNumber': '9876543210',
      'email': 'janesmith@example.com',
      'abhaAddress': 'jane.smith@abha',
    },
    {
      'id': 'P003',
      'firstName': 'Robert',
      'lastName': 'Johnson',
      'fullName': 'Robert Johnson',
      'dob': DateTime(1978, 3, 10),
      'age': 46,
      'gender': 'Male',
      'bloodGroup': 'B+',
      'mobileNumber': '9876543210',
      'email': 'robert@example.com',
      'abhaAddress': 'robert.johnson@abha',
    },
  ];

  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      'id': 'APT-001',
      'doctorName': 'Dr. Saad',
      'doctorSpecialization': 'Senior Physiotherapist',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '10:30 AM',
      'status': 'confirmed',
      'clinic': 'Hope Homeopathy - Main Branch',
    },
    {
      'id': 'APT-002',
      'doctorName': 'Dr. Saad',
      'doctorSpecialization': 'Senior Physiotherapist',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '2:00 PM',
      'status': 'pending',
      'clinic': 'Hope Homeopathy - Main Branch',
    },
  ];

  final List<Map<String, dynamic>> _completedAppointments = [
    {
      'id': 'APT-003',
      'doctorName': 'Dr. Saad',
      'doctorSpecialization': 'Senior Physiotherapist',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'time': '9:00 AM',
      'status': 'completed',
      'clinic': 'Hope Homeopathy - Main Branch',
      'rating': 4.5,
    },
    {
      'id': 'APT-004',
      'doctorName': 'Dr. Saad',
      'doctorSpecialization': 'Senior Physiotherapist',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'time': '3:30 PM',
      'status': 'completed',
      'clinic': 'Hope Homeopathy - Main Branch',
      'rating': 5.0,
    },
  ];

  final List<Map<String, dynamic>> _expiredAppointments = [
    {
      'id': 'APT-005',
      'doctorName': 'Dr. Saad',
      'doctorSpecialization': 'Senior Physiotherapist',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'time': '1:00 PM',
      'status': 'expired',
      'clinic': 'Hope Homeopathy - Main Branch',
    },
  ];

  // Blood group options
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
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshAppointments() {
    setState(() {
      for (var appointment in _upcomingAppointments) {
        if (appointment['status'] == 'pending') {
          appointment['status'] = 'confirmed';
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Appointments refreshed',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3).withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 2.h,
        ),
      ),
    );
  }

  void _showSelectPatientSheet() {
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
        description: 'Choose a patient to book appointment',
        onPatientSelected: (patient) {
          _navigateToBookingScreen(patient);
        },
      ),
    );
  }

  void _navigateToBookingScreen(Patient patient) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking appointment for ${patient.fullName}',
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

    // TODO: Navigate to booking appointment screen
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) => BookingAppointmentScreen(patient: patient),
    // ));
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final difference =
        date.difference(DateTime(today.year, today.month, today.day));

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else if (difference.inDays < 7 && difference.inDays > -7) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFFF9800);
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
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'expired':
        return 'Expired';
      default:
        return 'Unknown';
    }
  }

  Widget _buildAppointmentCard(
      Map<String, dynamic> appointment, bool isUpcoming) {
    final date = appointment['date'] as DateTime;
    final status = appointment['status'] as String;
    final statusColor = _getStatusColor(status);
    final formattedDate = _formatDate(date);

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
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
                    appointment['id'],
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 3.w),
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
                        appointment['doctorName'],
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        appointment['doctorSpecialization'],
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.8.h),
                      Text(
                        appointment['clinic'],
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.grey[500],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.5.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem(
                    icon: Iconsax.calendar,
                    title: 'Date',
                    value: formattedDate,
                    color: const Color(0xFF4CAF50),
                  ),
                  _buildDetailItem(
                    icon: Iconsax.clock,
                    title: 'Time',
                    value: appointment['time'],
                    color: const Color(0xFFFF9800),
                  ),
                  if (appointment.containsKey('rating'))
                    _buildDetailItem(
                      icon: Iconsax.star,
                      title: 'Rating',
                      value: '${appointment['rating']}/5',
                      color: const Color(0xFFFFC107),
                    ),
                ],
              ),
            ),
            SizedBox(height: 2.5.h),
            if (!isUpcoming && status == 'completed')
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

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Flexible(
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(height: 1.2.h),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
                Iconsax.calendar_remove,
                size: 12.w,
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'No Appointments',
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
              'You don\'t have any appointments in this category',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: Colors.grey[500],
              ),
            ),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: 70.w,
            child: ElevatedButton(
              onPressed: _showSelectPatientSheet,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 2.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: const Color(0xFF2196F3),
              ),
              child: Text(
                'Book Appointment',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
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
            SizedBox(
              height: 10.h,
              child: _buildAppBar(),
            ),
            SizedBox(
              height: 9.h,
              child: _buildTabs(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAppointmentsList(
                    appointments: _upcomingAppointments,
                    isUpcoming: true,
                  ),
                  _buildAppointmentsList(
                    appointments: _completedAppointments,
                    isUpcoming: false,
                  ),
                  _buildAppointmentsList(
                    appointments: _expiredAppointments,
                    isUpcoming: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 3.h),
        child: FloatingActionButton(
          onPressed: _showSelectPatientSheet,
          backgroundColor: const Color(0xFF2196F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Iconsax.calendar_add,
            size: 7.w,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              "My Appointments",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[50],
              border: Border.all(
                color: Colors.grey[200]!,
                width: 2,
              ),
            ),
            child: Center(
              child: IconButton(
                onPressed: _refreshAppointments,
                icon: Icon(
                  Iconsax.refresh,
                  color: const Color(0xFF2196F3),
                  size: 6.w,
                ),
                padding: EdgeInsets.zero,
                splashRadius: 6.w,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[100]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          labelColor: const Color(0xFF2196F3),
          unselectedLabelColor: Colors.grey[600],
          labelStyle: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.calendar_tick, size: 5.w),
                  SizedBox(width: 1.5.w),
                  Flexible(
                    child: Text(
                      'Upcoming',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.calendar_circle, size: 5.w),
                  SizedBox(width: 1.5.w),
                  Flexible(
                    child: Text(
                      'Completed',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.calendar_remove, size: 5.w),
                  SizedBox(width: 1.5.w),
                  Flexible(
                    child: Text(
                      'Expired',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList({
    required List<Map<String, dynamic>> appointments,
    required bool isUpcoming,
  }) {
    if (appointments.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        children: [
          ...appointments.map(
              (appointment) => _buildAppointmentCard(appointment, isUpcoming)),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
