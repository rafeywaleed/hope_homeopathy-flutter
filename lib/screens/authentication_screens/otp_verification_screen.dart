import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

import 'create_account_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(4, (index) => FocusNode());
  int _countdown = 30;
  bool _isResendEnabled = false;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 4.h, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
    _startCountdown();

    // Auto focus first OTP field after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    // Allow only digits
    if (value.isNotEmpty && !RegExp(r'^[0-9]$').hasMatch(value)) {
      _otpControllers[index].clear();
      return;
    }

    // Clear field if backspace is pressed on empty field
    if (value.isEmpty && index > 0) {
      _otpControllers[index - 1].clear();
      FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
      return;
    }

    // Move to next field if a digit is entered
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
    }

    // Check if all fields are filled
    bool allFilled =
        _otpControllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    String otp = _otpControllers.map((c) => c.text).join();

    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
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
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Thin black circular progress
                      SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, // Thinner line
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black87),
                          backgroundColor: Colors.transparent, // No background
                        ),
                      ),

                      // Simple black icon
                      Icon(
                        Iconsax.verify,
                        color: Colors.black87,
                        size: 10.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                FadeIn(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    'Verifying OTP...',
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
                    'To ${widget.phoneNumber}',
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
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pop(context); // Close dialog

    // Navigate to create profile screen
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateAccountScreen(phoneNumber: widget.phoneNumber),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
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
  }

  void _resendOtp() {
    // Clear all OTP fields
    for (var controller in _otpControllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_otpFocusNodes[0]);

    setState(() {
      _countdown = 30;
      _isResendEnabled = false;
    });
    _startCountdown();

    // Show success toast
    _showSuccessToast('OTP resent to ${widget.phoneNumber}');
  }

  void _showSuccessToast(String message) {
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
            color: const Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2196F3).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              // Minimal Background
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color(0xFFF8FAFF),
                      ],
                    ),
                  ),
                ),
              ),

              // Subtle Gradient Overlay (Removed BackdropFilter)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        const Color(0xFF2196F3).withOpacity(0.02),
                        const Color(0xFF2196F3).withOpacity(0.02),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Custom Back Button
                      FadeInDown(
                        duration: const Duration(milliseconds: 400),
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 11.w,
                              height: 11.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[50],
                                border: Border.all(
                                  color: Colors.grey[100]!,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                color: Colors.black87,
                                size: 6.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Title with Animation
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enter Code',
                                    style: GoogleFonts.inter(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                      letterSpacing: -1.0,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                        height: 1.4,
                                      ),
                                      children: [
                                        const TextSpan(
                                            text:
                                                'Enter the 4-digit code sent to\n'),
                                        TextSpan(
                                          text: widget.phoneNumber,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 6.h),

                      // OTP Input Fields with Proper Number Input
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 200),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNodes[index]);
                                  },
                                  child: Container(
                                    width: 18.w,
                                    height: 18.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _otpFocusNodes[index].hasFocus
                                            ? const Color(0xFF2196F3)
                                            : Colors.grey[200]!,
                                        width: _otpFocusNodes[index].hasFocus
                                            ? 2
                                            : 1,
                                      ),
                                      boxShadow: _otpFocusNodes[index].hasFocus
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF2196F3)
                                                    .withOpacity(0.1),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.02),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                    ),
                                    child: Center(
                                      child: TextField(
                                        controller: _otpControllers[index],
                                        focusNode: _otpFocusNodes[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        style: GoogleFonts.inter(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                          letterSpacing: -0.5,
                                        ),
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged: (value) =>
                                            _onOtpChanged(value, index),
                                        cursorColor: const Color(0xFF2196F3),
                                        cursorWidth: 2,
                                        showCursor: true,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Countdown Timer with Progress
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: _countdown / 30,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF2196F3),
                              ),
                              minHeight: 2,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Code expires in $_countdown seconds',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Resend Button
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 400),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: SizedBox(
                            width: double.infinity,
                            height: 7.h,
                            child: ElevatedButton(
                              onPressed: _isResendEnabled ? _resendOtp : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isResendEnabled
                                    ? const Color(0xFF2196F3)
                                    : Colors.grey[100],
                                foregroundColor: _isResendEnabled
                                    ? Colors.white
                                    : Colors.grey[400],
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    size: 5.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'Resend Code',
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
