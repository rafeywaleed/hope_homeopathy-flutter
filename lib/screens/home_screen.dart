import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentCarouselIndex = 0;
  int _currentToken = 42;
  late PageController _carouselController;
  late Timer _carouselTimer;

  final List<Map<String, dynamic>> _carouselItems = [
    {
      'image': 'assets/images/clinic_1.jpg',
      'title': 'Modern Facilities',
      'subtitle': 'State-of-the-art medical equipment',
    },
    {
      'image': 'assets/images/clinic_2.jpg',
      'title': 'Expert Care',
      'subtitle': 'Experienced medical professionals',
    },
    {
      'image': 'assets/images/clinic_3.jpg',
      'title': 'Comfortable Environment',
      'subtitle': 'Patient-focused care',
    },
    {
      'image': 'assets/images/clinic_4.jpg',
      'title': 'Emergency Services',
      'subtitle': '24/7 emergency care available',
    },
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(viewportFraction: 0.92);
    _startCarouselAutoScroll();
  }

  void _startCarouselAutoScroll() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentCarouselIndex < _carouselItems.length - 1) {
        _currentCarouselIndex++;
      } else {
        _currentCarouselIndex = 0;
      }
      if (mounted) {
        _carouselController.animateToPage(
          _currentCarouselIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _onCarouselPageChanged(int index) {
    if (mounted) {
      setState(() {
        _currentCarouselIndex = index;
      });
    }
  }

  void _navigateToTab(int index) {
    // Navigate to the corresponding tab in MainScreen
    final mainScreenState = context.findAncestorStateOfType<MainScreenState>();
    if (mainScreenState != null) {
      mainScreenState.navigateToTab(index);
    }
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _carouselTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(179, 243, 243, 243),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              _buildAppBar(),

              // Welcome Section
              _buildWelcomeSection(),

              SizedBox(height: 2.h),

              // Image Carousel
              _buildImageCarousel(),

              SizedBox(height: 3.h),

              // Quick Actions
              _buildQuickActions(),

              SizedBox(height: 3.h),

              // Live Token Tracker
              _buildTokenTracker(),

              SizedBox(height: 3.h),

              // Upcoming Appointments
              _buildUpcomingAppointments(),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Hope Homeopathy",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(221, 179, 132, 3),
                )),
            Container(
              width: 11.w,
              height: 11.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[50],
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Badge(
                  smallSize: 1.2.h,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Iconsax.notification,
                    color: Colors.grey[600],
                    size: 5.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 0.3.h),
            Text(
              'Patient Name',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'How can we assist you today?',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 100),
          child: SizedBox(
            height: 20.h,
            child: PageView.builder(
              controller: _carouselController,
              onPageChanged: _onCarouselPageChanged,
              itemCount: _carouselItems.length,
              itemBuilder: (context, index) {
                final item = _carouselItems[index];
                return AnimatedBuilder(
                  animation: _carouselController,
                  builder: (context, child) {
                    double pageOffset = 0;
                    if (_carouselController.position.haveDimensions) {
                      pageOffset = index - _carouselController.page!;
                    }
                    double scale = 1 - (pageOffset.abs() * 0.15);
                    double opacity = 1 - (pageOffset.abs() * 0.5);

                    return Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  item['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[100],
                                      child: Center(
                                        child: Icon(
                                          Icons.medical_services_outlined,
                                          size: 12.w,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: GoogleFonts.inter(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      item['subtitle'],
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: 1.5.h),
        FadeInUp(
          duration: const Duration(milliseconds: 900),
          delay: const Duration(milliseconds: 200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _carouselItems.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentCarouselIndex == index ? 6.w : 2.w,
                height: 2.w,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == index
                      ? const Color(0xFF2196F3)
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return FadeInUp(
      duration: const Duration(milliseconds: 900),
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Access',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 3.w,
              childAspectRatio: 1.3,
              children: [
                _buildQuickActionItem(
                  icon: Iconsax.calendar_add,
                  title: 'Book Appointment',
                  color: const Color(0xFF2196F3),
                  onTap: () {
                    // Handle book appointment
                  },
                ),
                _buildQuickActionItem(
                  icon: Iconsax.calendar_tick,
                  title: 'My Appointments',
                  color: const Color(0xFF4CAF50),
                  onTap: () =>
                      _navigateToTab(1), // Navigate to Appointments tab
                ),
                _buildQuickActionItem(
                  icon: Iconsax.note_text,
                  title: 'E-Prescriptions',
                  color: const Color(0xFFFF9800),
                  onTap: () =>
                      _navigateToTab(3), // Navigate to Prescriptions tab
                ),
                _buildQuickActionItem(
                  icon: Iconsax.hospital,
                  title: 'Clinic Services',
                  color: const Color(0xFF9C27B0),
                  onTap: () => _navigateToTab(2), // Navigate to Clinic tab
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[100]!,
            width: 1.5,
          ),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     color.withOpacity(0.03),
          //     color.withOpacity(0.01),
          //   ],
          // ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.03),
          //     blurRadius: 15,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container with subtle gradient
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.15),
                      color.withOpacity(0.08),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: color,
                    size: 7.w,
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Title with better typography
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.3,
                  letterSpacing: -0.2,
                ),
              ),

              // Subtle indicator for clickable
              SizedBox(height: 0.8.h),
              Container(
                width: 6.w,
                height: 0.3.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenTracker() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      delay: const Duration(milliseconds: 400),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[100]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Token Counter',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Currently serving',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Updated just now',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2196F3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Token',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '$_currentToken',
                      style: GoogleFonts.inter(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1100),
      delay: const Duration(milliseconds: 500),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Appointments',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToTab(1),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey[100]!,
                  width: 1,
                ),
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
                      child: Icon(
                        Iconsax.calendar,
                        color: const Color(0xFF2196F3),
                        size: 6.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Saad',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Senior Physiotherapist',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Wrap(
                          spacing: 2.w,
                          runSpacing: 1.w,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 0.6.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.calendar,
                                    size: 3.5.w,
                                    color: const Color(0xFF4CAF50),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Today',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF4CAF50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 0.6.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9800).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.clock,
                                    size: 3.5.w,
                                    color: const Color(0xFFFF9800),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '1:30 PM',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFFF9800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Iconsax.arrow_right_3,
                    color: Colors.grey[400],
                    size: 5.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
