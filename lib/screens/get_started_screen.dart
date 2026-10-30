import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haylou_rt2_smartwatch_app/constants/app_strings.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/app_title.dart';
import '../widgets/app_button.dart';
import '../widgets/watch_image.dart';
import '../widgets/exit_app_dialog.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _watchFade;
  late Animation<double> _watchScale;
  late Animation<Offset> _watchSlide;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _watchFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.65,
        curve: Curves.easeOut,
      ),
    );

    _watchScale = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.75,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _watchSlide = Tween<Offset>(
      begin: const Offset(0, -0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.80,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.50,
        1.0,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  Future<void> _showExitDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return const ExitAppDialog();
      },
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 120.h),
                FadeTransition(
                  opacity: _textFade,
                  child: const AppTitle(),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  child: Center(
                    child: FadeTransition(
                      opacity: _watchFade,
                      child: SlideTransition(
                        position: _watchSlide,
                        child: ScaleTransition(
                          scale: _watchScale,
                          child: WatchImage(
                            width: 290.w,
                            height: 290.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70.h),
                AppButton(
                  text: AppStrings.getStarted,
                  width: 0.82.sw,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.homeScreen,
                    );
                  },
                ),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}