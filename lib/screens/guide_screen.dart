import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haylou_rt2_smartwatch_app/constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_title.dart';
import '../widgets/feature_card.dart';
import '../widgets/step_card.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  // SizedBox(height: 28.h),
                  Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: AppTitle(),),
                            SizedBox(height: 30.h),
                            Text(
                              'Key Features',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 18.h),
                            FeatureCard(
                                title: 'Clean & Easy Interface',
                                description:
                                    'Navigate effortlessly through a well-organized layout designed to make every action simple and straightforward.'
                            ),
                            SizedBox(height: 14.h),
                            FeatureCard(
                                title: 'Quick Bluetooth Pairing',
                                description:
                                    'Instantly discover and link your smartwatch through your phones Bluetooth in just a few taps.'
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              'Quick Start Guide',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 18.h),
                            StepCard(
                                number: '01',
                                title: 'Scan for Devices',
                                description:
                                    'Hit the scan button to locate nearby watches. Make sure Bluetooth is turned on from your watch.'
                            ),
                            SizedBox(height: 14.h),
                            StepCard(
                                number: '02',
                                title: 'Tap to Connect',
                                description:
                                    'When your watch shows up in the list, simply tap it. The app takes care of the rest automatically.'
                            ),
                            SizedBox(height: 25.h),
                            Center(
                              child: Text(
                                'You’re All Set!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Sleek design, easy navigation, and a powerful engine - everything you need to pair your smartwatch effortlessly.\nSmart Watch App makes the whole process smooth and hassle-free.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14.sp,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 25.h),
                            Center(
                              child: AppButton(
                                text: AppStrings.gotIt,
                                width: 0.60.sw,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                   ),
                ],
              ),
          )
      ),
    );
  }
}
