import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haylou_rt2_smartwatch_app/constants/app_strings.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/app_title.dart';
import '../widgets/app_button.dart';
import '../widgets/watch_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppTitle(),
              SizedBox(height: 30.h),
              const WatchImage(
                width: 290,
                height: 290,
              ),
              SizedBox(height: 40.h),
              AppButton(
                text: AppStrings.guide,
                width: 0.70.sw,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.guideScreen,
                  );
                },
              ),
              SizedBox(height: 14.h),
              AppButton(
                text: AppStrings.connectWatch,
                width: 0.70.sw,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.connectWatchScreen,
                  );
                },
              ),
              SizedBox(height: 14.h),
              AppButton(
                text: AppStrings.settings,
                width: 0.70.sw,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.settingsScreen,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}