import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haylou_rt2_smartwatch_app/constants/app_strings.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/app_title.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/watch_image.dart';

class ConnectWatchScreen extends StatelessWidget {
  const ConnectWatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 45.h),
              AppTitle(),
              SizedBox(height: 30.h),
              const WatchImage(
                width: 290,
                height: 290,
              ),
              SizedBox(height: 40.h),
              AppButton(
                text: AppStrings.connectNewWatch,
                width: 0.60.sw,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.availableDevicesScreen,
                  );
                },
              ),
              SizedBox(height: 16.h),
              AppButton(
                text: AppStrings.pairedWatches,
                width: 0.60.sw,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.pairedDevicesScreen,
                  );
                },
              ),
              SizedBox(height: 35.h),
            ],
          ),
        ),
      ),
    );
  }
}