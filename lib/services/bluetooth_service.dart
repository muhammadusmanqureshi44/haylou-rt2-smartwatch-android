import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fb;
import 'package:flutter_blue_classic/flutter_blue_classic.dart' as classic;
import 'package:geolocator/geolocator.dart';

class BluetoothService {
  BluetoothService();

  final classic.FlutterBlueClassic _classicBluetooth =
  classic.FlutterBlueClassic(
    usesFineLocation: true,
  );

  Stream<classic.BluetoothDevice> get classicScanResults =>
      _classicBluetooth.scanResults;

  Future<List<classic.BluetoothDevice>>
  getClassicPairedDevices() async {
    final devices = await _classicBluetooth.bondedDevices;

    return devices ?? <classic.BluetoothDevice>[];
  }

  Future<void> startClassicScan() async {
    _classicBluetooth.startScan();
  }

  Future<void> stopClassicScan() async {
    _classicBluetooth.stopScan();
  }

  Future<bool> pairClassicDevice(
      classic.BluetoothDevice device,
      ) async {
    if (device.bondState ==
        classic.BluetoothBondState.bonded) {
      return true;
    }

    final result = await _classicBluetooth.bondDevice(
      device.address,
    );

    if (result != true) {
      return false;
    }

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    final bondedDevices =
    await getClassicPairedDevices();

    final address = device.address.toUpperCase();

    return bondedDevices.any(
          (bondedDevice) =>
      bondedDevice.address.toUpperCase() == address &&
          bondedDevice.bondState ==
              classic.BluetoothBondState.bonded,
    );
  }

  Future<bool> isClassicDevicePaired(
      classic.BluetoothDevice device,
      ) async {
    if (device.bondState ==
        classic.BluetoothBondState.bonded) {
      return true;
    }

    final bondedDevices =
    await getClassicPairedDevices();

    final address = device.address.toUpperCase();

    return bondedDevices.any(
          (bondedDevice) =>
      bondedDevice.address.toUpperCase() == address &&
          bondedDevice.bondState ==
              classic.BluetoothBondState.bonded,
    );
  }

  Stream<fb.BluetoothAdapterState> get adapterState =>
      fb.FlutterBluePlus.adapterState;

  Stream<List<fb.ScanResult>> get scanResults =>
      fb.FlutterBluePlus.onScanResults;

  Future<fb.BluetoothAdapterState>
  getCurrentBluetoothState() async {
    return fb.FlutterBluePlus.adapterState.first;
  }

  Future<LocationPermission>
  checkLocationPermission() async {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission>
  requestLocationPermission() async {
    return Geolocator.requestPermission();
  }

  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<bool> isBluetoothOn() async {
    final state =
    await getCurrentBluetoothState();

    return state == fb.BluetoothAdapterState.on;
  }

  Future<void> turnOnBluetooth() async {
    await fb.FlutterBluePlus.turnOn();
  }

  Future<void> startBleScan() async {
    await fb.FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10),
      androidCheckLocationServices: true,
    );
  }

  Future<void> stopBleScan() async {
    if (fb.FlutterBluePlus.isScanningNow) {
      await fb.FlutterBluePlus.stopScan();
    }
  }

  Future<void> pairDevice(
      fb.BluetoothDevice device,
      ) async {
    await device.createBond();
  }

  Future<void> connectDevice(
      fb.BluetoothDevice device,
      ) async {
    await device.connect(
      license: fb.License.nonprofit,
    );
  }

  Future<void> disconnectDevice(
      fb.BluetoothDevice device,
      ) async {
    if (device.isConnected) {
      await device.disconnect();
    }
  }

  Future<void> dispose() async {
    await stopBleScan();
    await stopClassicScan();
  }
}