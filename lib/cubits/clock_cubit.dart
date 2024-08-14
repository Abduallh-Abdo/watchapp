import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchapp/blue/blue.dart';
import 'package:watchapp/cubits/clock_states.dart';
import 'package:watchapp/models/saved_alarm_clock.dart';
import 'package:watchapp/widgets/custom_clock_picker.dart';
import 'package:watchapp/widgets/custom_time_picker.dart';

class ClockCubit extends Cubit<ClockStates> {
  ClockCubit() : super(ClockInitial());

  static ClockCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  bool isConnected = false;

  List<BluetoothDiscoveryResult> devices = [];
  bool isDiscovering = false;
  bool isConnecting = false;
  String? connectionStatus;
  String connectedDeviceName = 'non';
  TextEditingController textController = TextEditingController();
  TimeOfDay? selectedTime;
  TimeOfDay? selectedClock;
  bool startedTimer = false;
  bool startedClock = false;
  bool startedStopWatch = false;
  Timer? timerTimer;
  Timer? timerAlarm;
  Timer? timerStopWatch;
  Duration durationTimer = const Duration();
  Duration durationClock = const Duration(seconds: 0);
  Duration durationStopWatch = const Duration();
  Duration remainingTimer = const Duration();
  Duration remainingClock = const Duration(seconds: 0);
  Duration remainingStopWatch = const Duration();
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";

  int selectedHourAlarm = 00;
  int selectedMinuteAlarm = 00;
  bool isAM = true;
  TimeOfDay initialTimeAlarm = TimeOfDay.now();

  int selectedHourTimer = 00;
  int selectedMinuteTimer = 00;
  final TimeOfDay initialTime = TimeOfDay.now();

  List<String> laps = [];
  BlueDevice blueDevice = BlueDevice();

  List<SavedAlarmClock> listAlarmClock = [];
  late SharedPreferences prefs;
  bool isActiveClock = true;

  // List<Widget> screens = [
  //   // HomePage(),
  //   StopWatchPage(),
  //   TimerPage(),
  // ];

  // List<String> titles = [
  //   'Clock',
  //   'Timer',
  //   'Counter Clock',
  // ];
  getDataAlarmClock() async {
    prefs = await SharedPreferences.getInstance();
    List<String> stringList = prefs.getStringList("listAlarmClock") ?? [];
    if (stringList.isNotEmpty) {
      listAlarmClock = stringList
          .map(
            (item) => SavedAlarmClock.fromMap(json.decode(item)),
          )
          .toList();
    }

    emit(SharedprefState());
  }

  Future<void> removeDataAlarmClock(String selectedTime) async {
    listAlarmClock.removeWhere((element) => element.timeClock == selectedTime);

    List<String> stringList = listAlarmClock
        .map(
          (item) => json.encode(
            item.toMap(),
          ),
        )
        .toList();
    await prefs.setStringList("listAlarmClock", stringList);
    emit(SharedprefState());
  }

  Future<void> updateDataAlarmClock(String selectedTime, bool isActive) async {
    for (var element in listAlarmClock) {
      if (element.timeClock == selectedTime) {
        element.isActiveClock = isActive;
        break;
      }
    }

    List<String> stringList = listAlarmClock
        .map(
          (item) => json.encode(
            item.toMap(),
          ),
        )
        .toList();
    await prefs.setStringList("listAlarmClock", stringList);
    emit(SharedprefState());

    if (isActive == false) {
      blueDevice.sendData(
        "isActiveFalse",
        (bool sent) {
          connectionStatus = sent
              ? 'Pause message sent successfully'
              : 'Failed to send pause message';

          print('Pause message sent: $sent');
        },
      );
    } else {
      blueDevice.sendData(
        "isActiveTrue",
        (bool sent) {
          connectionStatus = sent
              ? 'Pause message sent successfully'
              : 'Failed to send pause message';

          print('Pause message sent: $sent');
        },
      );
    }
    emit(UpdateDataAlarmClockstate());
  }

  void updateDeviceName(String name) {
    blueDevice.updateDeviceName(name);
    emit(ConnectionDeviceState());
  }

  void updateConnectionStatus(String status) {
    blueDevice.updateStatus(status);
    emit(ConnectionDeviceState());
  }

  void updateConnectionsStatus(bool status) {
    blueDevice.updateConnectionsStatus(status);
    emit(ConnectionDeviceState());
  }

  void updateAMtimer(value) {
    isAM = value;
    emit(UpdateAMtimerState());
  }

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
      blueDevice.updateDeviceName(name);
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
    timerTimer?.cancel();

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
    timerTimer?.cancel();

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

      timerTimer = Timer.periodic(
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

  void startAlarm() {
    if (selectedClock != null) {
      startedClock = true;
      emit(StartButtonState());

      timerAlarm = Timer.periodic(
        Duration(seconds: 1),
        (timer) {
          if (remainingClock < durationClock) {
            remainingClock += Duration(seconds: 1);
          } else {
            timer.cancel();
            startedClock = false;
          }
          emit(ClockTickState(remainingClock: remainingClock));
        },
      );

      blueDevice.sendData("Alarm1", (bool sent) {
        connectionStatus = sent
            ? 'Start message sent successfully'
            : 'Failed to send start message';
        emit(StartButtonState());

        print('Start message sent: $sent');
      });
    }
  }

  void deleteAlarm() {
    timerAlarm?.cancel();

    startedClock = false;
    remainingClock = durationClock;
    emit(ResetButtonState());

    blueDevice.sendData("Alarm3", (bool sent) {
      connectionStatus = sent
          ? 'Reset message sent successfully'
          : 'Failed to send reset message';
      emit(ResetButtonState());

      print('Reset message sent: $sent');
    });
  }

  void stopAlarm() {
    timerAlarm?.cancel();

    startedClock = false;
    emit(StopButtonState());
    blueDevice.sendData("Alarm0", (bool sent) {
      connectionStatus = sent
          ? 'Pause message sent successfully'
          : 'Failed to send pause message';
      emit(StopButtonState());

      print('Pause message sent: $sent');
    });
  }

  void selectTime(context) async {
    TimeOfDay? pickedTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return CustomTimePicker();
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

  void selectAlarmClock(BuildContext context) async {
    TimeOfDay? pickedClock = await showModalBottomSheet<TimeOfDay>(
      backgroundColor: const Color(0xFF323F68),
      elevation: 20,
      enableDrag: true,
      isDismissible: true,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return const CustomClockPicker();
      },
    );

    if (pickedClock != null) {
      selectedClock = pickedClock;
      durationClock = Duration(
        hours: pickedClock.hour,
        minutes: pickedClock.minute,
      );

      // await setDataAlarmClock(pickedClock);
      emit(SelectTimeState());

      String selectedClockString =
          "${pickedClock.hour.toString().padLeft(2, '0')}:${pickedClock.minute.toString().padLeft(2, '0')}";

      print('Attempting to send selected clock: $selectedClockString');

      // set data for alarm clock
      listAlarmClock.insert(
        0,
        SavedAlarmClock(
          timeClock: selectedClockString,
          isActiveClock: isActiveClock,
        ),
      );

      List<String> stringList = listAlarmClock
          .map(
            (item) => json.encode(item.toMap()),
          )
          .toList();

      await prefs.setStringList("listAlarmClock", stringList);
      emit(SharedprefState());

      blueDevice.sendData(
        "SelectedTime:$selectedClockString",
        (bool sent) {
          connectionStatus = sent
              ? 'Selected clock sent successfully'
              : 'Failed to send selected clock';
          emit(SelectTimeState());
          print('Selected time message sent: $sent');
        },
      );
    }
  }

  // Future<void> setDataAlarmClock(TimeOfDay selectedTime) async {
  //   final formattedAlarm =
  //       "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

  //   listAlarmClock.insert(
  //     0,
  //     SavedAlarmClock(
  //       timeClock: formattedAlarm,
  //       isActiveClock: isActiveClock,
  //     ),
  //   );

  //   List<String> stringList = listAlarmClock
  //       .map(
  //         (item) => json.encode(item.toMap()),
  //       )
  //       .toList();

  //   await prefs.setStringList("listAlarmClock", stringList);
  //   emit(SharedprefState());
  // }

  void stopStopWatch() {
    timerStopWatch?.cancel();

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
    timerStopWatch?.cancel();

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

    timerStopWatch = Timer.periodic(Duration(seconds: 1), (timer) {
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

  void updateHourNumberPicker(value) {
    selectedHourAlarm = value;
    emit(UpdateNumberPickerState());
  }

  void updateMinNumberPicker(value) {
    selectedMinuteAlarm = value;
    emit(UpdateNumberPickerState());
  }

  void upadateHourTimer(value) {
    selectedHourTimer = value;
    emit(UpdateTimerState());
  }

  void upadateMinTimer(value) {
    selectedMinuteTimer = value;
    emit(UpdateTimerState());
  }
}
