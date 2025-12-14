import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:clinic_app/screens/authentication_screens/create_account_screen.dart';
import 'package:clinic_app/screens/authentication_screens/otp_verification_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  late AnimationController _scaleController;
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isPhoneValid = false;
  bool _isLoading = false;
  String _errorMessage = '';

  final List<Map<String, dynamic>> _sliderData = [
    {
      'title': 'Expert Medical Care',
      'subtitle': 'Connect with top specialists\nfrom your home',
      'color': const Color(0xFFE3F2FD),
      'gradient': [const Color(0xFFE3F2FD), const Color(0xFFF3E5F5)],
      'svg': 'assets/svg/doctor.svg',
      'icon': Icons.medical_services,
    },
    {
      'title': 'Instant Appointments',
      'subtitle': 'Book appointments instantly\nwith real-time availability',
      'color': const Color(0xFFE8F5E9),
      'gradient': [const Color(0xFFE8F5E9), const Color(0xFFF1F8E9)],
      'svg': 'assets/svg/calendar.svg',
      'icon': Icons.calendar_today,
    },
    {
      'title': 'Digital Prescriptions',
      'subtitle': 'Access your prescriptions\nanytime, anywhere',
      'color': const Color(0xFFFFF3E0),
      'gradient': [const Color(0xFFFFF3E0), const Color(0xFFFFF8E1)],
      'svg': 'assets/svg/prescription.svg',
      'icon': Icons.medical_information,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _phoneController.addListener(_validatePhoneNumber);

    _scaleController.forward();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _sliderData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  void _validatePhoneNumber() {
    final text = _phoneController.text;

    // Remove any non-digit characters
    final cleanedText = text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedText != text) {
      final selection = _phoneController.selection;
      _phoneController.text = cleanedText;
      _phoneController.selection = selection.copyWith(
        baseOffset: cleanedText.length,
        extentOffset: cleanedText.length,
      );
    }

    setState(() {
      if (cleanedText.isEmpty) {
        _isPhoneValid = false;
        _errorMessage = '';
      } else if (cleanedText.length < 10) {
        _isPhoneValid = false;
        _errorMessage = 'Enter a valid 10-digit number';
      } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanedText)) {
        _isPhoneValid = false;
        _errorMessage = 'Enter a valid Indian mobile number';
      } else {
        _isPhoneValid = true;
        _errorMessage = '';
      }
    });
  }

  bool _isValidIndianMobileNumber(String number) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(number);
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();

    final phoneNumber = _phoneController.text.trim();

    if (!_isPhoneValid) {
      _showErrorToast(_errorMessage.isNotEmpty
          ? _errorMessage
          : 'Please enter a valid phone number');
      return;
    }

    if (!_isValidIndianMobileNumber(phoneNumber)) {
      _showErrorToast('Please enter a valid Indian mobile number');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Show loading dialog
    _showLoadingDialog(phoneNumber);
  }

  void _showErrorToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        elevation: 0,
        margin: EdgeInsets.only(
          bottom: 15.h,
          left: 5.w,
          right: 5.w,
        ),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLoadingDialog(String phoneNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
        child: ElasticIn(
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rotating loading icon
                Spin(
                  infinite: true,
                  duration: const Duration(seconds: 1),
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      ),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: Colors.white,
                      size: 10.w,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                FadeIn(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    'Sending OTP...',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                FadeIn(
                  delay: const Duration(milliseconds: 700),
                  child: Text(
                    'To +91 $phoneNumber',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      setState(() {
        _isLoading = false;
      });

      // Navigate to OTP screen with fade transition
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OtpVerificationScreen(
            phoneNumber: phoneNumber,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _scaleController.dispose();
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background Slides
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _sliderData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildSlide(index);
                },
              ),
            ),

            // Page Indicators
            Positioned(
              top: 8.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _sliderData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == index ? 6.w : 2.w,
                    height: 2.w,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Auth Form
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildAuthForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(int index) {
    final data = _sliderData[index];
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data['gradient'],
        ),
      ),
      child: Stack(
        children: [
          _buildAnimatedBackground(),
          Padding(
            padding: EdgeInsets.only(
              top: 12.h,
              bottom: 45.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 4.w),
                    child: ElasticIn(
                      duration: const Duration(milliseconds: 1200),
                      child: FadeIn(
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 45.w,
                              height: 45.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Pulse(
                                  infinite: true,
                                  duration: const Duration(seconds: 2),
                                  child: Container(
                                    width: 35.w,
                                    height: 35.w,
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.9),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 25,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      data['svg'],
                                      color: Colors.blueAccent,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.only(right: 6.w, left: 2.w),
                    child: SlideInLeft(
                      from: 50,
                      duration: const Duration(milliseconds: 1000),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInDown(
                            delay: const Duration(milliseconds: 300),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Text(
                                data['title'],
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                  height: 1.3,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          FadeInUp(
                            delay: const Duration(milliseconds: 500),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                data['subtitle'],
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        Positioned(
          top: 10.h,
          right: 5.w,
          child: FadeInRight(
            delay: const Duration(milliseconds: 400),
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 30.h,
          left: 5.w,
          child: FadeInLeft(
            delay: const Duration(milliseconds: 600),
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 20.h,
          left: 15.w,
          child: Bounce(
            from: 5,
            infinite: true,
            duration: const Duration(seconds: 3),
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40.h,
          right: 15.w,
          child: Spin(
            infinite: true,
            duration: const Duration(seconds: 20),
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthForm() {
    return Container(
      width: 100.w,
      padding: EdgeInsets.only(
        left: 6.w,
        right: 6.w,
        top: 4.h,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 2.h
            : 4.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Welcome Text
          FadeIn(
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                Text(
                  'Welcome to MediCare',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Your health, our priority',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Phone Number Input
          FadeIn(
            delay: const Duration(milliseconds: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _errorMessage.isNotEmpty
                          ? Colors.orangeAccent
                          : Colors.grey[200]!,
                      width: _errorMessage.isNotEmpty ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.05),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                          ),
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+91',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Icon(
                              Icons.expand_more_rounded,
                              size: 16.sp,
                              color: Colors.grey[500],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: TextField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter mobile number',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: Colors.grey[500],
                              ),
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 2.h),
                              errorStyle: const TextStyle(height: 0),
                            ),
                            cursorColor: const Color(0xFF667EEA),
                            cursorWidth: 2,
                            onSubmitted: (_) {
                              if (_isPhoneValid) {
                                _onLoginPressed();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.only(left: 1.w),
                    child: Text(
                      _errorMessage,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Continue Button
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: SizedBox(
              width: 100.w,
              height: 6.5.h,
              child: ElevatedButton(
                onPressed:
                    _isPhoneValid && !_isLoading ? _onLoginPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  disabledBackgroundColor:
                      const Color(0xFF667EEA).withOpacity(0.3),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16.sp,
                          ),
                        ],
                      ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Terms and Privacy
          FadeIn(
            delay: const Duration(milliseconds: 600),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'By continuing, you agree to our ',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: Colors.grey[500],
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: const Color(0xFF667EEA),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: const Color(0xFF667EEA),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
