import 'package:clinic_app/screens/authentication_screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.profile_circle,
                  size: 10.w,
                  color: Colors.grey[400],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Profile',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your profile information will appear here',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ));
              },
              child: Text("Auth Screen"),
            )
          ],
        ),
      ),
    );
  }
}
