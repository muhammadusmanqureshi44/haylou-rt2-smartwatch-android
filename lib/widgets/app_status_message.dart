import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class AppStatusMessage extends StatefulWidget {
  const AppStatusMessage({
    super.key,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  @override
  State<AppStatusMessage> createState() => _AppStatusMessageState();
}

class _AppStatusMessageState extends State<AppStatusMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;

  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF151A20),
              borderRadius: BorderRadius.circular(16.r),

              border: Border.all(
                color: AppColors.border,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.35,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42.w,
                  height: 42.h,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius:
                    BorderRadius.circular(12.r),
                  ),
                  child: Image.asset(
                    'assets/images/smartwatch.png',
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Text(
                    widget.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13.sp,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                if (widget.buttonText != null &&
                    widget.onButtonPressed != null) ...[
                  SizedBox(width: 6.w),

                  TextButton(
                    onPressed:
                    widget.onButtonPressed,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 4.h,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      widget.buttonText!,
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}