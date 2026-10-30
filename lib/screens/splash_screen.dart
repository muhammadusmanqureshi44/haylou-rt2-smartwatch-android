import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/app_title.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/watch_image.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _goToGetStarted();
  }

  Future<void> _goToGetStarted() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.getStartedScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTitle(),
            SizedBox(height: 35.h),
            WatchImage(
              width: 290.w,
              height: 290.h,
            ),
            SizedBox(height: 60.h),
            SizedBox(
              width: 150.w,
              child: LinearProgressIndicator(
                minHeight: 5.h,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}