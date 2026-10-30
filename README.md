# Haylou RT2 Smart Watch App 

A Flutter-based Android smartwatch companion application designed to discover, pair, and manage nearby Bluetooth devices through a clean and modern user interface.

The application integrates Bluetooth Classic and Bluetooth Low Energy (BLE) functionality to scan for available devices and provides Android system settings support for Bluetooth, location services, and battery optimization.

## Overview

**Haylou RT2 Smart Watch App** is built with Flutter and Dart, focusing on Bluetooth device discovery, device pairing, and Android device management.

The application features a modern dark-themed interface, reusable UI components, and dedicated screens for device discovery and settings.

## Features

- **Bluetooth Classic Scanning** – Discover nearby Bluetooth Classic devices.
- **Bluetooth Low Energy (BLE) Scanning** – Search for BLE-enabled devices.
- **Device Discovery** – Display available Bluetooth devices in the application.
- **Device Pairing** – Initiate Bluetooth device pairing and handle success or failure states.
- **Paired Devices** – Access paired Bluetooth device information.
- **Bluetooth Management** – Check Bluetooth adapter status and request Bluetooth activation.
- **Location Permissions** – Request and manage Android location permissions required for scanning.
- **Location Services** – Check location service availability and open Android location settings.
- **Power Optimization** – Access Android battery optimization settings.
- **Scan Status Updates** – Display scanning progress, discovered device counts, and status messages.
- **Responsive UI** – Adapt the interface to different screen sizes.
- **Reusable Components** – Maintain consistent UI elements across application screens.

## Application Screens

- Splash Screen
- Get Started Screen
- Guide Screen
- Home Screen
- Connect Watch Screen
- Available Devices Screen
- Paired Devices Screen
- Settings Screen

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform UI framework |
| Dart | Application programming language |
| Flutter Blue Plus | Bluetooth Low Energy functionality |
| Flutter Blue Classic | Bluetooth Classic functionality |
| Geolocator | Location permissions and location services |
| Permission Handler | Runtime permission management |
| Flutter ScreenUtil | Responsive screen sizing |
| Android Intent Plus | Android system settings integration |
| Material Design | User interface components |

## Project Structure

```text
lib/
├── constants/
│   └── app_strings.dart
│
├── routes/
│   └── app_routes.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── get_started_screen.dart
│   ├── guide_screen.dart
│   ├── home_screen.dart
│   ├── connect_watch_screen.dart
│   ├── available_devices_screen.dart
│   ├── paired_devices_screen.dart
│   └── settings_screen.dart
│
├── services/
│   └── bluetooth_service.dart
│
├── theme/
│   ├── app_colors.dart
│   └── app_theme.dart
│
├── widgets/
│   ├── app_appbar_widget.dart
│   ├── app_button.dart
│   ├── app_status_message.dart
│   ├── app_title.dart
│   ├── available_device_card.dart
│   ├── exit_app_dialog.dart
│   ├── feature_card.dart
│   ├── settings_option_tile.dart
│   ├── step_card.dart
│   └── watch_image.dart
│
└── main.dart

assets/
├── app_icon/
│   └── watch_app_icon.png
│
└── images/
    └── smartwatch.png

Requirements

Flutter SDK

Dart SDK

Android Studio

Android SDK

Android device with Bluetooth support

Android Configuration

Minimum Android SDK: API 24

Compile SDK: API 36

Target SDK: API 36

Getting Started

1. Clone the Repository

git clone https://github.com/muhammadusmanqureshi44/haylou-rt2-smartwatch-android.git

2. Open the Project

cd haylou-rt2-smartwatch-android

3. Install Dependencies

flutter pub get

4. Run the Application

Connect an Android device or start an Android emulator, then run:

flutter run

5. Build APK

To generate a release APK:

flutter build apk --release

The generated APK will be available at:

build/app/outputs/flutter-apk/app-release.apk

Permissions

The application uses Android runtime permissions and system settings required for Bluetooth device discovery and management.

Depending on the Android version and device, these may include:

Bluetooth Scan

Bluetooth Connect

Location permissions

Location services access

Users may need to enable Bluetooth and location services to discover nearby devices.

Design

The application uses a dark navy-blue theme with reusable widgets and consistent styling.

The UI is organized into separate screens and reusable components to keep the codebase maintainable and easy to extend.

Developer

Usman Qureshi

Flutter Developer

GitHub: muhammadusmanqureshi44

License

This project is available for educational and portfolio purposes. Contact the author before redistributing or using it commercially.
│   └──
