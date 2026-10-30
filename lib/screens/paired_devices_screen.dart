import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart' as classic;
import 'package:haylou_rt2_smartwatch_app/constants/app_strings.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/app_appbar_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/bluetooth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_status_message.dart';

class PairedDevicesScreen extends StatefulWidget {
  const PairedDevicesScreen({super.key});

  @override
  State<PairedDevicesScreen> createState() =>
      _PairedDevicesScreenState();
}

class _PairedDevicesScreenState
    extends State<PairedDevicesScreen> {
  final BluetoothService _bluetoothService =
  BluetoothService();
  List<classic.BluetoothDevice> _pairedDevices = [];
  bool _isLoading = true;
  bool _isBluetoothOn = false;
  bool _isTurningOnBluetooth = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _checkBluetoothAndLoadDevices();
  }

  Future<bool> _requestBluetoothPermission() async {
    try {
      final status =
      await Permission.bluetoothConnect.request();

      if (status.isGranted) {
        return true;
      }

      if (!mounted) return false;

      _showStatusMessage(
        'Bluetooth is required to view paired devices',
      );

      return false;
    } catch (_) {
      if (!mounted) return false;

      _showStatusMessage(
        'Bluetooth is required to view paired devices',
      );

      return false;
    }
  }

  void _showStatusMessage(String message) {
    if (!mounted) return;

    setState(() {
      _statusMessage = message;
    });

    Future.delayed(
      const Duration(seconds: 3),
          () {
        if (!mounted) return;

        setState(() {
          _statusMessage = null;
        });
      },
    );
  }

  Future<void> _checkBluetoothAndLoadDevices() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final permission =
      await Permission.bluetoothConnect.status;

      if (!permission.isGranted) {
        final granted =
        await _requestBluetoothPermission();

        if (!mounted) return;

        if (!granted) {
          setState(() {
            _isBluetoothOn = false;
            _pairedDevices = [];
            _isLoading = false;
          });

          return;
        }
      }

      final bluetoothOn =
      await _bluetoothService.isBluetoothOn();

      if (!mounted) return;

      if (!bluetoothOn) {
        setState(() {
          _isBluetoothOn = false;
          _pairedDevices = [];
          _isLoading = false;
        });

        return;
      }

      final devices =
      await _bluetoothService.getClassicPairedDevices();

      if (!mounted) return;

      setState(() {
        _isBluetoothOn = true;
        _pairedDevices = devices;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isBluetoothOn = false;
        _pairedDevices = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _turnOnBluetooth() async {
    if (_isTurningOnBluetooth) {
      return;
    }

    final permission =
    await Permission.bluetoothConnect.status;

    if (!permission.isGranted) {
      final granted =
      await _requestBluetoothPermission();

      if (!granted) {
        return;
      }
    }

    if (!mounted) return;

    setState(() {
      _isTurningOnBluetooth = true;
    });

    try {
      await _bluetoothService.turnOnBluetooth();

      await Future.delayed(
        const Duration(milliseconds: 1000),
      );

      final bluetoothOn =
      await _bluetoothService.isBluetoothOn();

      if (!mounted) return;

      if (bluetoothOn) {
        setState(() {
          _isTurningOnBluetooth = false;
        });

        await _checkBluetoothAndLoadDevices();
      } else {
        setState(() {
          _isTurningOnBluetooth = false;
        });

        _showStatusMessage(
          'Bluetooth is required to view paired devices',
        );
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isTurningOnBluetooth = false;
      });

      _showStatusMessage(
        'Bluetooth is required to view paired devices',
      );
    }
  }

  String _getDeviceName(
      classic.BluetoothDevice device,
      ) {
    final name = device.name?.trim() ?? '';

    if (name.isNotEmpty) {
      return name;
    }

    final alias = device.alias?.trim() ?? '';

    if (alias.isNotEmpty) {
      return alias;
    }

    return 'Bluetooth Device';
  }

  Widget _buildDeviceCard(
      classic.BluetoothDevice device,
      ) {
    final name = _getDeviceName(device);
    final address = device.address.trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBluetoothOffView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 35.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 82.w,
              height: 82.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 78.w,
                    height: 78.w,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.bluetooth_rounded,
                      size: 42.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Positioned(
                    right: 2.w,
                    bottom: 2.w,
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.textPrimary,
                        size: 21.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 22.h),
            Text(
              'Bluetooth is Off',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 21.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please turn it on to view paired devices',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 25.h),
            AppButton(
              text: _isTurningOnBluetooth
                  ? 'Turning On...'
                  : AppStrings.turnOnBluetooth,
              width: 0.55.sw,
              onPressed: _isTurningOnBluetooth
                  ? () {}
                  : _turnOnBluetooth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 40.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82.w,
              height: 82.w,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Icon(
                Icons.bluetooth_disabled_rounded,
                size: 40.sp,
                color: AppColors.accent,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No Paired Devices',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'No Bluetooth devices are currently paired with this phone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(
        title: AppStrings.pairedDevices,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
              ),
            )
                : !_isBluetoothOn
                ? _buildBluetoothOffView()
                : _pairedDevices.isEmpty
                ? _buildEmptyView()
                : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                20.w,
                20.h,
                20.w,
                100.h,
              ),
              itemCount:
              _pairedDevices.length,
              separatorBuilder:
                  (_, __) =>
                  SizedBox(height: 12.h),
              itemBuilder:
                  (context, index) {
                return _buildDeviceCard(
                  _pairedDevices[index],
                );
              },
            ),
            if (_statusMessage != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 10.h,
                child: AppStatusMessage(
                  key: ValueKey(_statusMessage),
                  message: _statusMessage!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }
}