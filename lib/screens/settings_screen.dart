import 'dart:async';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haylou_rt2_smartwatch_app/constants/app_strings.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/app_appbar_widget.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/app_title.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/watch_image.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/settings_option_tile.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/app_status_message.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  bool _isBluetoothOn = false;
  String? _statusMessage;
  Timer? _statusTimer;

  late AnimationController _watchAnimationController;
  late Animation<double> _watchFloatAnimation;
  late Animation<double> _watchScaleAnimation;

  @override
  void initState() {
    super.initState();

    _watchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _watchFloatAnimation = Tween<double>(
      begin: -6,
      end: 2,
    ).animate(
      CurvedAnimation(
        parent: _watchAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _watchScaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _watchAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _watchAnimationController.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  void _showStatusMessage(String message) {
    _statusTimer?.cancel();

    setState(() {
      _statusMessage = message;
    });

    _statusTimer = Timer(
      const Duration(milliseconds: 2500),
          () {
        if (!mounted) return;

        setState(() {
          _statusMessage = null;
        });
      },
    );
  }

  void _toggleBluetooth(bool value) {
    setState(() {
      _isBluetoothOn = value;
    });

    if (value) {
      _showStatusMessage('Bluetooth is enabled');
    }
  }

  Future<void> _openPowerOptimization() async {
    try {
      const intent = AndroidIntent(
        action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      );

      await intent.launch();
    } catch (e) {
      if (!mounted) return;

      _showStatusMessage(
        'Unable to open Power Optimization settings.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(
        title: AppStrings.settings,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  10.h,
                  20.w,
                  30.h,
                ),
                child: Column(
                  children: [
                    const AppTitle(),
                    SizedBox(height: 20.h),
                    Container(
                      height: 300.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: AnimatedBuilder(
                          animation: _watchAnimationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                _watchFloatAnimation.value,
                              ),
                              child: Transform.scale(
                                scale: _watchScaleAnimation.value,
                                child: child,
                              ),
                            );
                          },
                          child: WatchImage(
                            height: 150.h,
                            width: 150.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    SettingsOptionTile(
                      icon: Icons.bluetooth_rounded,
                      title: 'Enable Bluetooth',
                      subtitle:
                      'Manage your watch Bluetooth connection',
                      trailing: Switch(
                        value: _isBluetoothOn,
                        onChanged: _toggleBluetooth,
                        activeThumbColor: AppColors.accent,
                        activeTrackColor:
                        AppColors.accent.withValues(alpha: 0.35),
                        inactiveThumbColor:
                        AppColors.textSecondary,
                        inactiveTrackColor:
                        AppColors.primaryLight,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SettingsOptionTile(
                      icon: Icons.battery_saver_rounded,
                      iconColor: AppColors.success,
                      title: 'Power Optimization',
                      subtitle:
                      'Allow the app to run properly in the background',
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.textSecondary,
                        size: 18.sp,
                      ),
                      onTap: _openPowerOptimization,
                    ),
                  ],
                ),
              ),
            ),

            if (_statusMessage != null)
              AppStatusMessage(
                message: _statusMessage!,
              ),
          ],
        ),
      ),
    );
  }
}