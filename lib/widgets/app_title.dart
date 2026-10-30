import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haylou_rt2_smartwatch_app/constants/app_strings.dart';
import '../theme/app_colors.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: AppStrings.appName,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: AppStrings.modelName,
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          AppStrings.appSubtitle,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}