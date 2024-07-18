import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart';

class BlueDevice {
  // final BluetoothStateNotifier connectionProvider;
  BluetoothConnection? connection;
  String _deviceName = 'Unknown Device';
  String _connectionStatus = 'Not Connected';
  bool _isConnected = false;

  String get deviceName => _deviceName;
  String get connectionStatus => _connectionStatus;
  bool get isConnected => _isConnected;

  Future<bool> connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device: $address');
      _isConnected = true;
      
      sendTime();
      
      return true;
    
    } catch (exception) {
      
      print('Cannot connect, exception occurred: $exception');
      _isConnected = false;
      return false;
    }
  }

  void sendTime() {
    if (connection != null && connection!.isConnected) {
      String currentTime = DateFormat('HH:mm').format(DateTime.now());
      connection!.output.add(
        Uint8List.fromList(
          utf8.encode(currentTime),
        ),
      );
      print('Current time sent: $currentTime');
    }
  }

  void sendData(String data, Function(bool) onSent) {
    if (connection != null && connection!.isConnected) {
      try {
        data = data.trim();
        connection!.output.add(
          Uint8List.fromList(
            utf8.encode(data),
          ),
        );
        connection!.output.allSent.then((_) {
          print('Data sent: $data');
          onSent(true);
        }).catchError((error) {
          print('Failed to send data: $error');
          onSent(false);
        });
      } catch (e) {
        print('Failed to send data: $e');
        onSent(false);
      }
    } else {
      print('No connection established to send data');
      onSent(false);
    }
  }

  // void disconnect() {
  //   if (connection != null) {
  //     connection!.close();
  //     connection = null;
  //     connectionProvider.updateConnectionsStatus(false);
  //   }
  // }
}
