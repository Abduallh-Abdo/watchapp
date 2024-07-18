import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watchapp/blue/blue.dart';
import 'package:watchapp/cubits/clock_states.dart';
import 'package:watchapp/views/timer_page.dart';
import 'package:watchapp/views/stop_watch_page.dart';
import 'package:watchapp/widgets/custom_time_picker.dart';

class ClockCubit extends Cubit<ClockStates> {
  ClockCubit() : super(ClockInitial());

  static ClockCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  //  String _deviceName = 'Unknown Device';
  // String _connectionStatus = 'Not Connected';
  bool isConnected = false;

  // String get deviceName => _deviceName;
  // String get connectionStatus => _connectionStatus;
  // bool get isConnected => _isConnected;
  List<BluetoothDiscoveryResult> devices = [];
  bool isDiscovering = false;
  bool isConnecting = false;
  String? connectionStatus;
  String connectedDeviceName = '';
  // late BlueDevice blueDevice ;
  TextEditingController textController = TextEditingController();
  TimeOfDay? selectedTime;
  bool startedTimer = false;
  bool startedStopWatch = false;
  Timer? timer;
  Duration durationTimer = Duration();
  Duration durationStopWatch = Duration();
  Duration remainingTimer = Duration();
  Duration remainingStopWatch = Duration();
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";

  List<String> laps = [];

  BlueDevice blueDevice = BlueDevice();

  List<Widget> screens = [
    // HomePage(),
    StopWatchPage(),
    TimerPage(),
  ];

  List<String> titles = [
    'Clock',
    'Timer',
    'Counter Clock',
  ];

  // void updateDeviceName(String name) {
  //   _deviceName = name;
  //   emit(ConnectionDeviceState());
  // }

  // void updateConnectionStatus(String status) {
  //   _connectionStatus = status;
  //   emit(ConnectionDeviceState());
  // }
  // void updateConnectionsStatus(bool status) {
  //   _isConnected = status;
  //   emit(ConnectionDeviceState());
  // }

  Future<void> checkPermissions(context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (allGranted) {
      enableBluetooth();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissions are required to use Bluetooth')),
      );
    }
  }

  Future<void> enableBluetooth() async {
    BluetoothState state = await FlutterBluetoothSerial.instance.state;
    if (state == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    startDiscovery();
  }

  void startDiscovery() {
    isDiscovering = true;
    devices = [];
    emit(StartDiscoveryState());

    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      devices.add(result);
      emit(StartDiscoveryState());
    }).onDone(() {
      isDiscovering = false;
      emit(StartDiscoveryState());
    });
  }

  void connectToDevice(String name, String address) async {
    isConnecting = true;
    connectionStatus = 'Connecting to $name';
    emit(StartDiscoveryState());

    bool success = await blueDevice.connect(address);

    isConnecting = false;
    connectionStatus =
        success ? 'Connected to $name' : 'Failed to connect to $name';
    if (success) {
      connectedDeviceName = name; // Update connectedDeviceName
      // blueDevice.updateDeviceName(name);
      // bluetoothState.updateConnectionStatus('Connected');
    } else {
      connectedDeviceName = ''; // Reset connectedDeviceName
      // bluetoothState.updateConnectionStatus('Failed to connect');
    }
    emit(StartDiscoveryState());
  }

  void sendData(String data) {
    blueDevice.sendData(data, (bool sent) {
      connectionStatus =
          sent ? 'Data sent successfully' : 'Failed to send data';
    });
    emit(SendDataState());
  }

  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(ChangeCurrentIndexState());
  }

  void stopTimer() {
    timer?.cancel();

    startedTimer = false;
    emit(StopButtonState());
    blueDevice.sendData("Timer0", (bool sent) {
      connectionStatus = sent
          ? 'Pause message sent successfully'
          : 'Failed to send pause message';
      emit(StopButtonState());

      print('Pause message sent: $sent');
    });
  }

  void resetTimer() {
    timer?.cancel();

    startedTimer = false;
    remainingTimer = durationTimer;
    emit(ResetButtonState());

    blueDevice.sendData("Timer3", (bool sent) {
      connectionStatus = sent
          ? 'Reset message sent successfully'
          : 'Failed to send reset message';
      emit(ResetButtonState());

      print('Reset message sent: $sent');
    });
  }

  void startTimer() {
    if (selectedTime != null) {
      startedTimer = true;
      emit(StartButtonState());

      timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) {
          if (remainingTimer.inSeconds > 0) {
            remainingTimer -= Duration(seconds: 1);
          } else {
            timer.cancel();
            startedTimer = false;
          }
          emit(StartButtonState());
        },
      );
      blueDevice.sendData("Timer1", (bool sent) {
        connectionStatus = sent
            ? 'Start message sent successfully'
            : 'Failed to send start message';
        emit(StartButtonState());

        print('Start message sent: $sent');
      });
    }
  }

  void selectTime(context) async {
    TimeOfDay? pickedTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return CustomTimePicker(
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
      },
    );

    if (pickedTime != null) {
      selectedTime = pickedTime;
      durationTimer = Duration(
        hours: pickedTime.hour,
        minutes: pickedTime.minute,
      );
      remainingTimer = durationTimer;
      emit(SelectTimeState());

      String selectedTimeString =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";

      print('Attempting to send selected time: $selectedTimeString');

      blueDevice.sendData("SelectedTime:$selectedTimeString", (bool sent) {
        connectionStatus = sent
            ? 'Selected time sent successfully'
            : 'Failed to send selected time';
        emit(SelectTimeState());
        print('Selected time message sent: $sent');
      });
    }
  }

  void stopStopWatch() {
    timer?.cancel();

    startedStopWatch = false;
    emit(StopButtonState());
    blueDevice.sendData("StopWatch0", (bool sent) {
      connectionStatus = sent
          ? 'Pause message sent successfully'
          : 'Failed to send pause message';
      emit(StopButtonState());

      print('Stop message sent: $sent');
    });
  }

  void resetStopWatch() {
    timer?.cancel();
    
      seconds = 0;
      minutes = 0;
      hours = 0;
      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";
      startedStopWatch = false;
      laps.clear();
       emit(ResetButtonState());

    blueDevice.sendData("StopWatch3", (bool sent) {
     
        connectionStatus = sent
            ? 'Reset message sent successfully'
            : 'Failed to send reset message';
          emit(ResetButtonState());

      print('Reset message sent: $sent');
    });
  }

  void addLapsStopWatch() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    
      laps.add(lap);
       emit(AddButtonState());

  }

  void startStopWatch() {
    
      startedStopWatch = true;
        emit(StartButtonState());

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
             emit(StartButtonState());

    });
    blueDevice.sendData("StopWatch1", (bool sent) {
              emit(StartButtonState());

        connectionStatus = sent
            ? 'Start message sent successfully'
            : 'Failed to send start message';
     
      print('Start message sent: $sent');
    });
  }
  
}
