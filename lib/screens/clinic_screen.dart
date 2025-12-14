import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io' show Platform;

class ClinicInfoScreen extends StatefulWidget {
  const ClinicInfoScreen({Key? key}) : super(key: key);

  @override
  _ClinicInfoScreenState createState() => _ClinicInfoScreenState();
}

class _ClinicInfoScreenState extends State<ClinicInfoScreen>
    with SingleTickerProviderStateMixin {
  // Real clinic data from Google Maps
  final String clinicName = "Hope Homoeopathy";
  final String tagline =
      "Asthma, Migraine, Skin & Hair, Allergy & Women's Health";
  final String address =
      "Safa Plaza, next to suprabhat tiffins, Officers Colony, Chanchalguda, Hyderabad, Telangana 500024";
  final String phoneNumber = "+91 92921 00992";
  final String website = "hopehomoeopathy.com";
  final double rating = 5.0;
  final int totalReviews = 53;

  // Clinic status
  bool _isOpen = true;
  String _currentStatus = "Open now";

  // Timer for cards carousel
  late Timer _carouselTimer;
  late PageController _carouselController;
  int _currentCarouselIndex = 0;

  String get _staticMapUrl {
    return 'https://maps.google.com/maps/api/staticmap'
        '?center=$_latitude,$_longitude'
        '&zoom=15'
        '&size=600x300'
        '&markers=color:red%7C$_latitude,$_longitude';
  }

  // Cards for carousel
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'Services Offered',
      'subtitle':
          'Comprehensive homeopathic treatments for various health conditions',
      'icon': Iconsax.health,
      'color': Color(0xFF667EEA),
      'gradient': [Color(0xFF667EEA), Color(0xFF764BA2)],
    },
    {
      'title': 'Specializations',
      'subtitle':
          'Expert care in classical & clinical homeopathy with holistic approach',
      'icon': Iconsax.award,
      'color': Color(0xFFF093FB),
      'gradient': [Color(0xFFF093FB), Color(0xFFF5576C)],
    },
    {
      'title': 'Patient Reviews',
      'subtitle':
          '5.0 rating with 53+ satisfied patients sharing their experiences',
      'icon': Iconsax.star,
      'color': Color(0xFF4FACFE),
      'gradient': [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    },
  ];

  // Weekly schedule from provided data
  final Map<String, String> _weeklySchedule = {
    'Saturday': '10:00 AM - 10:00 PM',
    'Sunday': '10:00 AM - 10:00 PM',
    'Monday': '10:00 AM - 10:00 PM',
    'Tuesday': '10:00 AM - 10:00 PM',
    'Wednesday': '10:00 AM - 10:00 PM',
    'Thursday': '10:00 AM - 10:00 PM',
    'Friday': 'Closed',
  };

  // Services offered from the clinic name
  final List<String> _services = [
    'Asthma Treatment',
    'Migraine Management',
    'Skin Disorders',
    'Hair Problems',
    'Allergy Treatment',
    "Women's Health",
    'Blood Pressure',
    'Chronic Diseases',
    'Pediatric Care',
  ];

  // Specializations
  final List<String> _specializations = [
    'Classical Homoeopathy',
    'Clinical Homoeopathy',
    'Holistic Treatment',
    'Chronic Disease Management',
    'Family Medicine',
    'Preventive Healthcare',
  ];

  // Clinic photos from provided Google Maps links
  final List<String> _clinicPhotos = [
    'https://lh3.googleusercontent.com/p/AF1QipNhtCjVMnG51Zu0ciKFRvYESpxorJQMtZvEUYS5=w400-h197-k-no',
    'https://www.google.com/maps/place/Hope+Homoeopathy+-+Asthma,+Migraine,+Skin+%26+Hair,+Allergy+%26+Women%E2%80%99s+Health+%7C+Malakpet,+Hyderabad/@17.373777,78.4985131,3a,75y,90t/data=!3m8!1e2!3m6!1sAF1QipNhtCjVMnG51Zu0ciKFRvYESpxorJQMtZvEUYS5!2e10!3e12!6shttps:%2F%2Flh3.googleusercontent.com%2Fp%2FAF1QipNhtCjVMnG51Zu0ciKFRvYESpxorJQMtZvEUYS5%3Dw203-h100-k-no!7i1362!8i672!4m9!3m8!1s0x3bcb983621a490f7:0x23004bc36ed161cc!8m2!3d17.3738797!4d78.4984255!10e5!14m1!1BCgIgARICEAE!16s%2Fg%2F11ddxt6678?entry=ttu&g_ep=EgoyMDI1MTIwOS4wIKXMDSoASAFQAw%3D%3D#',
    'https://www.google.com/maps/place/Hope+Homoeopathy+-+Asthma,+Migraine,+Skin+%26+Hair,+Allergy+%26+Women%E2%80%99s+Health+%7C+Malakpet,+Hyderabad/@17.373777,78.4985131,3a,112.1y,90t/data=!3m8!1e2!3m6!1sAF1QipN9eAjVcPEufIjq_WCeIVem-0V0y7aC-ObA4mIR!2e10!3e12!6shttps:%2F%2Flh3.googleusercontent.com%2Fp%2FAF1QipN9eAjVcPEufIjq_WCeIVem-0V0y7aC-ObA4mIR%3Dw203-h127-k-no!7i653!8i410!4m9!3m8!1s0x3bcb983621a490f7:0x23004bc36ed161cc!8m2!3d17.3738797!4d78.4984255!10e5!14m1!1BCgIgARICEAE!16s%2Fg%2F11ddxt6678?entry=ttu&g_ep=EgoyMDI1MTIwOS4wIKXMDSoASAFQAw%3D%3D#',
    'https://lh3.googleusercontent.com/p/AF1QipN9eAjVcPEufIjq_WCeIVem-0V0y7aC-ObA4mIR=w653-h410-k-no',
  ];

  // Reviews from provided data
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Mirza Anas Baig',
      'rating': 5.0,
      'date': '2 months ago',
      'comment':
          'I am satisfied with the service at this clinic. The doctor listen carefully explain everything clearly and provides treatment with good care. Staff is also polite & supportive & the overall experience is very very good.',
    },
    {
      'name': 'Asma Ali',
      'rating': 5.0,
      'date': '6 months ago',
      'comment':
          'Mashallah everything was very well organized and the staff members were professional. I would recommend others to use this golden opportunity. Dr.Saad is one of the most caring doctors who listens to patients problem and helps them.',
    },
    {
      'name': 'Husna Ahmed',
      'rating': 5.0,
      'date': '6 months ago',
      'comment':
          'The doctor pays careful attention to the patients problems while at the same time cross questions the patient and prescribes the medicines which in my case have been very effective in the treatment process.',
    },
  ];

  // Google Maps location
  final double _latitude = 17.3738797;
  final double _longitude = 78.4984255;
  final String _googleMapsUrl = "https://maps.app.goo.gl/D8BjRCXmGtqtgBDA7";

  @override
  void initState() {
    super.initState();
    _checkIfOpen();
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

  void _checkIfOpen() {
    final now = DateTime.now();
    final hour = now.hour;
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday

    // Check if it's Friday (closed)
    if (weekday == 5) {
      // Friday is weekday 5
      setState(() {
        _isOpen = false;
        _currentStatus = "Closed today";
      });
      return;
    }

    // Check hours (10 AM to 10 PM)
    if (hour >= 10 && hour < 22) {
      setState(() {
        _isOpen = true;
        _currentStatus = "Open now";
      });
    } else {
      setState(() {
        _isOpen = false;
        _currentStatus = "Closed now";
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _openMaps() async {
    await _launchUrl(_googleMapsUrl);
  }

  Future<void> _callClinic() async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri telUri = Uri.parse('tel:$cleanNumber');
    await _launchUrl(telUri.toString());
  }

  Future<void> _sendSms() async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri smsUri = Uri.parse('sms:$cleanNumber');
    await _launchUrl(smsUri.toString());
  }

  Future<void> _openWhatsApp() async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final String url = 'https://wa.me/91$cleanNumber';
    await _launchUrl(url);
  }

  Future<void> _openWebsite() async {
    final String url = 'https://$website';
    await _launchUrl(url);
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _isOpen
            ? const Color(0xFF4CAF50).withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isOpen ? const Color(0xFF4CAF50) : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isOpen ? const Color(0xFF4CAF50) : Colors.red,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            _currentStatus,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: _isOpen ? const Color(0xFF4CAF50) : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 22.h,
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
                        margin: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: item['gradient'],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: item['color'].withOpacity(0.3),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      item['subtitle'],
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.4,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                        vertical: 1.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Learn More',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 16.w,
                                height: 16.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Icon(
                                    item['icon'],
                                    color: Colors.white,
                                    size: 8.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _carouselItems.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentCarouselIndex == index ? 24 : 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentCarouselIndex == index
                    ? Color(0xFF667EEA)
                    : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGrid() {
    if (_clinicPhotos.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clinic Photos',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: _openMaps,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2196F3),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 3.w,
          childAspectRatio: 1.2,
          children: _clinicPhotos.map((photoUrl) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: Icon(
                          Iconsax.gallery,
                          size: 8.w,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScheduleTable() {
    final today = DateFormat('EEEE').format(DateTime.now());

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[100]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.calendar,
                color: const Color(0xFF2196F3),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Weekly Schedule',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ..._weeklySchedule.entries.map((entry) {
            final isToday = entry.key == today;
            return Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.key,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight:
                              isToday ? FontWeight.w700 : FontWeight.w500,
                          color: isToday
                              ? const Color(0xFF2196F3)
                              : Colors.grey[700],
                        ),
                      ),
                      if (isToday)
                        Container(
                          margin: EdgeInsets.only(left: 1.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.5.w,
                            vertical: 0.3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Today',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2196F3),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    entry.value,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      color:
                          isToday ? const Color(0xFF2196F3) : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildContactButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _callClinic,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
              foregroundColor: const Color(0xFF4CAF50),
              elevation: 0,
            ),
            icon: Icon(Iconsax.call, size: 5.w),
            label: Text(
              'Call',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _sendSms,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFFFF9800).withOpacity(0.1),
              foregroundColor: const Color(0xFFFF9800),
              elevation: 0,
            ),
            icon: Icon(Iconsax.message, size: 5.w),
            label: Text(
              'Message',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _openWhatsApp,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF25D366).withOpacity(0.1),
              foregroundColor: const Color(0xFF25D366),
              elevation: 0,
            ),
            icon: Icon(Iconsax.message, size: 5.w),
            label: Text(
              'WhatsApp',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Location',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: _openMaps,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    'Open in Maps',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Icon(
                    Iconsax.arrow_right_3,
                    size: 3.w,
                    color: const Color(0xFF2196F3),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),

        /// MAP PREVIEW
        GestureDetector(
          onTap: _openMaps,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 20.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  /// Static map image
                  Image.network(
                    _staticMapUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[100],
                        child: Center(
                          child: Icon(
                            Iconsax.map,
                            size: 8.w,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),

                  /// Subtle overlay + label
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.location,
                            size: 4.w,
                            color: const Color(0xFF2196F3),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Chanchalguda, Hyderabad',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Iconsax.arrow_right_3,
                            size: 3.w,
                            color: const Color(0xFF2196F3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Clinic Information",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    _buildStatusBadge(),
                  ],
                ),
              ),

              // Clinic Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinicName,
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      tagline,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Icon(
                          Iconsax.star1,
                          size: 4.w,
                          color: const Color(0xFFFFC107),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          rating.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '($totalReviews reviews)',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Featured Cards Carousel
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: _buildCustomCarousel(),
              ),

              SizedBox(height: 3.h),

              // Clinic Photos Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: _buildPhotoGrid(),
              ),

              SizedBox(height: 3.h),

              // Weekly Schedule
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: _buildScheduleTable(),
              ),

              SizedBox(height: 3.h),

              // Map Preview
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: _buildMapPreview(),
              ),

              SizedBox(height: 3.h),

              // Contact Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: _buildContactButtons(),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
