import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fb;
import 'package:flutter_blue_classic/flutter_blue_classic.dart' as classic;
import 'package:geolocator/geolocator.dart';
import 'package:haylou_rt2_smartwatch_app/constants/app_strings.dart';
import 'package:haylou_rt2_smartwatch_app/widgets/app_button.dart';
import '../services/bluetooth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_message.dart';
import '../widgets/available_device_card.dart';

class AvailableDevicesScreen extends StatefulWidget {
  const AvailableDevicesScreen({super.key});

  @override
  State<AvailableDevicesScreen> createState() =>
      _AvailableDevicesScreenState();
}

class _AvailableDevicesScreenState extends State<AvailableDevicesScreen> {
  final BluetoothService _bluetoothService = BluetoothService();
  final List<classic.BluetoothDevice> _classicDevices = [];
  final List<fb.BluetoothDevice> _bleDevices = [];
  StreamSubscription<classic.BluetoothDevice>?
  _classicScanSubscription;
  StreamSubscription<List<fb.ScanResult>>? _bleScanSubscription;
  StreamSubscription<fb.BluetoothAdapterState>? _adapterSubscription;
  bool _isRefreshing = false;
  bool _isScanning = false;
  bool _isPairing = false;
  String _scanStatus = '';

  int get _totalDevices =>
      _classicDevices.length + _bleDevices.length;

  @override
  void initState() {
    super.initState();

    _classicScanSubscription =
        _bluetoothService.classicScanResults.listen(
          _handleClassicDevice,
          onError: (_) {},
        );

    _bleScanSubscription =
        _bluetoothService.scanResults.listen(
          _handleBleResults,
          onError: (_) {
            if (!mounted) return;

            setState(() {
              _scanStatus = '';
            });
          },
        );

    _adapterSubscription =
        _bluetoothService.adapterState.listen(
              (state) {
            if (!mounted) return;

            if (state != fb.BluetoothAdapterState.on && _isScanning) {
              _stopScanning(showMessage: true);
            }
          },
        );
  }

  void _handleClassicDevice(
      classic.BluetoothDevice device,
      ) {
    if (!mounted) return;

    final address = device.address.trim().toUpperCase();

    if (address.isEmpty) return;

    final alreadyExists = _classicDevices.any(
          (existing) =>
      existing.address.toUpperCase() == address,
    );

    if (alreadyExists) return;

    setState(() {
      _classicDevices.add(device);
      _scanStatus =
      'Scanning... Found $_totalDevices device(s)';
    });
  }

  void _handleBleResults(
      List<fb.ScanResult> results,
      ) {
    if (!mounted) return;

    bool changed = false;

    for (final result in results) {
      final device = result.device;
      final name = _getBleDeviceName(device);

      if (name == null) continue;

      final duplicateClassic = _classicDevices.any(
            (classicDevice) =>
        classicDevice.address.toUpperCase() ==
            device.remoteId.toString().toUpperCase(),
      );

      if (duplicateClassic) continue;

      final alreadyExists = _bleDevices.any(
            (existing) => existing.remoteId == device.remoteId,
      );

      if (!alreadyExists) {
        _bleDevices.add(device);
        changed = true;
      }
    }

    if (changed) {
      setState(() {
        _scanStatus =
        'Scanning... Found $_totalDevices device(s)';
      });
    }
  }

  String? _getBleDeviceName(
      fb.BluetoothDevice device,
      ) {
    final platformName = device.platformName.trim();

    if (platformName.isNotEmpty) {
      return platformName;
    }

    final advertisedName = device.advName.trim();

    if (advertisedName.isNotEmpty) {
      return advertisedName;
    }

    return null;
  }

  String _getClassicDeviceName(
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

    return 'Unknown Device';
  }

  Future<void> _scanDevices() async {
    if (_isScanning || _isPairing) {
      return;
    }

    LocationPermission permission =
    await _bluetoothService.checkLocationPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await _bluetoothService.requestLocationPermission();
    }

    if (permission == LocationPermission.denied) {
      if (!mounted) return;

      _showStatusMessage(
        'Location permission is required to scan for devices',
      );

      return;
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;

      _showStatusMessage(
        'Location permission is disabled',
        buttonText: 'Open Settings',
        onButtonPressed: () async {
          await Geolocator.openAppSettings();
        },
        duration: const Duration(seconds: 6),
      );

      return;
    }

    final locationEnabled =
    await _bluetoothService.isLocationServiceEnabled();

    if (!locationEnabled) {
      if (!mounted) return;

      _showLocationRequiredMessage();

      return;
    }

    final bluetoothOn =
    await _bluetoothService.isBluetoothOn();

    if (!bluetoothOn) {
      try {
        await _bluetoothService.turnOnBluetooth();
      } catch (_) {
        if (!mounted) return;

        _showStatusMessage(
          'Bluetooth must be enabled to scan for devices',
        );

        return;
      }

      final bluetoothNowOn =
      await _bluetoothService.isBluetoothOn();

      if (!bluetoothNowOn) {
        if (!mounted) return;

        _showStatusMessage(
          'Bluetooth must be enabled to scan for devices',
        );

        return;
      }
    }

    if (!mounted) return;

    setState(() {
      _classicDevices.clear();
      _bleDevices.clear();
      _isScanning = true;
      _scanStatus = 'Scanning for devices...';
    });

    try {
      await _bluetoothService.startClassicScan();
      await _bluetoothService.startBleScan();

      await Future.delayed(
        const Duration(seconds: 10),
      );

      if (!mounted) return;

      await _bluetoothService.stopClassicScan();
      await _bluetoothService.stopBleScan();

      _finishScan();
    } catch (_) {
      if (!mounted) return;

      await _bluetoothService.stopClassicScan();
      await _bluetoothService.stopBleScan();

      setState(() {
        _isScanning = false;
        _scanStatus = '';
      });

      _showStatusMessage('Scanning failed');
    }
  }

  void _finishScan() {
    if (!mounted) return;

    setState(() {
      _isScanning = false;

      if (_totalDevices == 0) {
        _scanStatus = 'Scan completed';
      } else {
        _scanStatus =
        'Scan completed. Found $_totalDevices device(s)';
      }
    });

    if (_totalDevices == 0) {
      _showStatusMessage(
        'Scan completed. No devices were found.',
      );
    }
  }

  Future<void> _stopScanning({
    bool showMessage = false,
  }) async {
    if (!_isScanning) return;

    await _bluetoothService.stopClassicScan();
    await _bluetoothService.stopBleScan();

    if (!mounted) return;

    setState(() {
      _isScanning = false;

      if (_totalDevices == 0) {
        _scanStatus = '';
      } else {
        _scanStatus =
        'Scan completed. Found $_totalDevices device(s)';
      }
    });

    if (showMessage) {
      _showStatusMessage('Scanning cancelled');
    }
  }

  Future<void> _refreshDevices() async {
    if (_isRefreshing || _isPairing || _isScanning) {
      return;
    }

    await _bluetoothService.stopClassicScan();
    await _bluetoothService.stopBleScan();

    if (!mounted) return;

    setState(() {
      _isRefreshing = true;
      _isScanning = false;
      _scanStatus = '';
      _classicDevices.clear();
      _bleDevices.clear();
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> _pairClassicDevice(
      classic.BluetoothDevice device,
      ) async {
    if (_isPairing || _isScanning) {
      return;
    }

    final name = _getClassicDeviceName(device);

    final alreadyPaired =
    await _bluetoothService.isClassicDevicePaired(device);

    if (alreadyPaired) {
      if (!mounted) return;

      _showStatusMessage(
        '$name is already paired',
      );

      return;
    }

    if (!mounted) return;

    setState(() {
      _isPairing = true;
    });

    _showStatusMessage(
      'Pairing with $name...',
      duration: const Duration(seconds: 10),
    );

    try {
      final success =
      await _bluetoothService.pairClassicDevice(device);

      if (!mounted) return;

      setState(() {
        _isPairing = false;
      });

      if (success) {
        _showStatusMessage(
          '$name paired successfully',
        );
      } else {
        _showStatusMessage(
          'Pairing failed with $name',
        );
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isPairing = false;
      });

      _showStatusMessage(
        'Pairing failed with $name',
      );
    }
  }

  Future<void> _pairBleDevice(
      fb.BluetoothDevice device,
      ) async {
    if (_isPairing || _isScanning) {
      return;
    }

    final name =
        _getBleDeviceName(device) ?? 'Bluetooth Device';

    if (!mounted) return;

    setState(() {
      _isPairing = true;
    });

    _showStatusMessage(
      'Pairing with $name...',
      duration: const Duration(seconds: 10),
    );

    try {
      await _bluetoothService.pairDevice(device);
      await _bluetoothService.connectDevice(device);

      if (!mounted) return;

      setState(() {
        _isPairing = false;
      });

      _showStatusMessage(
        '$name paired successfully',
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isPairing = false;
      });

      _showStatusMessage(
        'Pairing failed with $name',
      );
    }
  }

  void _showStatusMessage(
      String message, {
        String? buttonText,
        VoidCallback? onButtonPressed,
        Duration duration = const Duration(seconds: 2),
      }) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: AppStatusMessage(
          message: message,
          buttonText: buttonText,
          onButtonPressed: onButtonPressed,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(
          left: 0,
          right: 0,
          bottom: 90.h,
        ),
      ),
    );
  }

  void _showLocationRequiredMessage() {
    _showStatusMessage(
      'Location is required for Bluetooth scanning',
      buttonText: 'Enable Location',
      onButtonPressed: () async {
        await Geolocator.openLocationSettings();
      },
      duration: const Duration(seconds: 6),
    );
  }

  Future<void> _handleBack() async {
    if (_isScanning) {
      await _bluetoothService.stopClassicScan();
      await _bluetoothService.stopBleScan();

      if (!mounted) return;

      setState(() {
        _isScanning = false;

        if (_totalDevices == 0) {
          _scanStatus = '';
        } else {
          _scanStatus =
          'Scan completed. Found $_totalDevices device(s)';
        }
      });

      _showStatusMessage('Scanning cancelled');

      return;
    }

    if (_isPairing) {
      return;
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _classicScanSubscription?.cancel();
    _bleScanSubscription?.cancel();
    _adapterSubscription?.cancel();

    _bluetoothService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isScanning && !_isPairing,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: _isPairing ? null : _handleBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          title: const Text(
            AppStrings.availableDevices,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              onPressed:
              (_isRefreshing ||
                  _isScanning ||
                  _isPairing)
                  ? null
                  : _refreshDevices,
              tooltip: 'Refresh',
              icon: _isRefreshing
                  ? const SizedBox(
                width: 21,
                height: 21,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(
                    AppColors.textPrimary,
                  ),
                ),
              )
                  : const Icon(
                Icons.refresh_rounded,
                color: AppColors.textPrimary,
                size: 27,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (_isScanning)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    0,
                  ),
                  child: _ScanningBox(
                    status: _scanStatus.isEmpty
                        ? 'Scanning for devices...'
                        : _scanStatus,
                  ),
                )
              else if (_scanStatus.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    0,
                  ),
                  child: _ScanStatusText(
                    text: _scanStatus,
                  ),
                ),
              Expanded(
                child: _totalDevices == 0
                    ? const _EmptyDevicesView()
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    24,
                  ),
                  itemCount: _totalDevices,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index <
                        _classicDevices.length) {
                      final device =
                      _classicDevices[index];

                      return AvailableDeviceCard(
                        deviceName:
                        _getClassicDeviceName(
                          device,
                        ),
                        onTap: () =>
                            _pairClassicDevice(device),
                      );
                    }

                    final bleIndex =
                        index - _classicDevices.length;

                    final device =
                    _bleDevices[bleIndex];

                    final name =
                    _getBleDeviceName(device)!;

                    return AvailableDeviceCard(
                      deviceName: name,
                      onTap: () =>
                          _pairBleDevice(device),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 45.h,
                ),
                child: AppButton(
                  onPressed:
                  (_isScanning || _isPairing)
                      ? () {}
                      : _scanDevices,
                  text: _isScanning
                      ? 'Scanning...'
                      : AppStrings.scanDevice,
                  width: 0.55.sw,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanningBox extends StatelessWidget {
  const _ScanningBox({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              status,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanStatusText extends StatelessWidget {
  const _ScanStatusText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyDevicesView extends StatelessWidget {
  const _EmptyDevicesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.watch_outlined,
                size: 42,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'No Devices Found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Make sure your smartwatch is nearby and ready to connect.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}