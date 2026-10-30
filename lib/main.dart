import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haylou_rt2_smartwatch_app/routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SmartWatchApp());
}

class SmartWatchApp extends StatelessWidget {
  const SmartWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Haylou RT 2 Smart Watch',
          theme: AppTheme.darkTheme,
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: AppRoutes.splashScreen,

        );
      },
    );
  }
}
