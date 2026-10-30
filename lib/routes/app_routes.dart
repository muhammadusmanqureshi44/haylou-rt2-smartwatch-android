import 'package:flutter/material.dart';
import 'package:haylou_rt2_smartwatch_app/screens/connect_watch_screen.dart';
import 'package:haylou_rt2_smartwatch_app/screens/guide_screen.dart';
import 'package:haylou_rt2_smartwatch_app/screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/get_started_screen.dart';
import '../screens/available_devices_screen.dart';
import '../screens/paired_devices_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String getStartedScreen = '/get-started';
  static const String homeScreen = '/home';
  static const String guideScreen = '/guide';
  static const String connectWatchScreen = '/connect-watch';
  static const String availableDevicesScreen = '/available-devices';
  static const String pairedDevicesScreen = '/paired-devices';
  static const String settingsScreen = '/settings';

  static Route<dynamic> generateRoute(
      RouteSettings settings,
      ) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case getStartedScreen:
        return MaterialPageRoute(
          builder: (_) => const GetStartedScreen(),
        );

      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case guideScreen:
        return MaterialPageRoute(
          builder: (_) => const GuideScreen(),
        );

      case connectWatchScreen:
        return MaterialPageRoute(
          builder: (_) => const ConnectWatchScreen(),
        );

      case availableDevicesScreen:
        return MaterialPageRoute(
          builder: (_) => const AvailableDevicesScreen(),
        );

      case pairedDevicesScreen:
        return MaterialPageRoute(
          builder: (_) => const PairedDevicesScreen(),
        );

      case settingsScreen:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}