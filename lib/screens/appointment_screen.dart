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
      builder: (context) => _buildSelectPatientSheet(),
    );
  }

  void _showAddPatientSheet() {
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
        onPatientAdded: (newPatient) {
          setState(() {
            _patients.add(newPatient);
          });
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
          // Reopen select patient sheet after a delay
          Future.delayed(const Duration(milliseconds: 500), () {
            _showSelectPatientSheet();
          });
        },
      ),
    );
  }

  Widget _buildSelectPatientSheet() {
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
                'Select Patient',
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
            'Choose a patient to book appointment',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 3.h),

          // Add New Patient Button
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
              onPressed: () {
                Navigator.pop(context); // Close select sheet
                _showAddPatientSheet(); // Open add patient sheet
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
            child: ListView.builder(
              itemCount: _patients.length,
              itemBuilder: (context, index) {
                final patient = _patients[index];
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
                      Navigator.pop(context);
                      _navigateToBookingScreen(patient);
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
                          patient['firstName'][0],
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2196F3),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      patient['fullName'],
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
                              '${patient['age']} years • ${patient['gender']}',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(
                              Iconsax.call,
                              size: 3.5.w,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              patient['mobileNumber'],
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        if (patient['bloodGroup'] != null) ...[
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
                                'Blood Group: ${patient['bloodGroup']}',
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
                    trailing: Icon(
                      Iconsax.arrow_right_3,
                      size: 5.w,
                      color: Colors.grey[400],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToBookingScreen(Map<String, dynamic> patient) {
    // This will navigate to the booking screen (to be created later)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking appointment for ${patient['fullName']}',
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

// Separate Widget for Add Patient Sheet
class AddPatientSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onPatientAdded;

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
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate:
                  DateTime.now().subtract(const Duration(days: 365 * 25)),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
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

          final newPatient = {
            'id':
                'P${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'fullName':
                '${_firstNameController.text} ${_lastNameController.text}',
            'dob': _selectedDate,
            'age': DateTime.now().difference(_selectedDate!).inDays ~/ 365,
            'gender': _selectedGender,
            'bloodGroup': _selectedBloodGroup != 'Select Blood Group'
                ? _selectedBloodGroup
                : null,
            'mobileNumber': _userMobile,
            'email':
                _emailController.text.isNotEmpty ? _emailController.text : null,
            'abhaAddress':
                _abhaController.text.isNotEmpty ? _abhaController.text : null,
          };

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
