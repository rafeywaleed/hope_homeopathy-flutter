import 'package:clinic_app/screens/clinic_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax/iconsax.dart';

import 'package:clinic_app/screens/home_screen.dart';
import 'package:clinic_app/screens/appointment_screen.dart';
import 'package:clinic_app/screens/prescription_screen.dart';
import 'package:clinic_app/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const HomeScreen(),
    const AppointmentsScreen(),
    const ClinicInfoScreen(),
    const PrescriptionsScreen(),
    const ProfileScreen(),
  ];

  // Public method to change tab from child widgets
  void navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: GNav(
              haptic: true,
              tabActiveBorder: Border.all(color: Colors.grey, width: 1),
              tabBorderRadius: 24,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              gap: 8,
              color: Colors.grey[600]!,
              iconSize: 5.w,
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.5.h,
              ),
              tabs: [
                GButton(
                  icon: Iconsax.home_2,
                  text: 'Home',
                  textStyle: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GButton(
                  icon: Iconsax.calendar_1,
                  text: 'Appointments',
                  textStyle: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GButton(
                  icon: Iconsax.heart_tick,
                  text: 'Clinic',
                  textStyle: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GButton(
                  icon: Iconsax.note_text,
                  text: 'Prescriptions',
                  textStyle: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GButton(
                  icon: Iconsax.profile_circle,
                  text: 'Profile',
                  textStyle: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
