import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/cubits/clock_states.dart';

class BluetoothPage extends StatelessWidget {
  // Future<void> checkPermissions() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.location,
  //     Permission.bluetooth,
  //     Permission.bluetoothScan,
  //     Permission.bluetoothConnect,
  //   ].request();

  //   bool allGranted = statuses.values.every((status) => status.isGranted);

  //   if (allGranted) {
  //     enableBluetooth();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Permissions are required to use Bluetooth')),
  //     );
  //   }
  // }

  // Future<void> enableBluetooth() async {
  //   BluetoothState state = await FlutterBluetoothSerial.instance.state;
  //   if (state == BluetoothState.STATE_OFF) {
  //     await FlutterBluetoothSerial.instance.requestEnable();
  //   }
  //   startDiscovery();
  // }

  // void startDiscovery() {
  //   setState(() {
  //     isDiscovering = true;
  //     devices = [];
  //   });

  //   FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
  //     setState(() {
  //       devices.add(result);
  //     });
  //   }).onDone(() {
  //     setState(() {
  //       isDiscovering = false;
  //     });
  //   });
  // }

  // void connectToDevice(String name, String address) async {
  //   setState(() {
  //     isConnecting = true;
  //     connectionStatus = 'Connecting to $name';
  //   });

  //   bool success = await clockCubit.blueDevice.connect(address);
  //   final bluetoothState = context.read<BluetoothStateNotifier>();

  //   setState(() {
  //     isConnecting = false;
  //     connectionStatus =
  //         success ? 'Connected to $name' : 'Failed to connect to $name';
  //     if (success) {
  //       connectedDeviceName = name; // Update connectedDeviceName
  //       bluetoothState.updateDeviceName(name);
  //       bluetoothState.updateConnectionStatus('Connected');
  //     } else {
  //       connectedDeviceName = ''; // Reset connectedDeviceName
  //       bluetoothState.updateConnectionStatus('Failed to connect');
  //     }
  //   });
  // }

  // void sendData(String data) {
  //   clockCubit.blueDevice.sendData(data, (bool sent) {
  //     setState(() {
  //       connectionStatus =
  //           sent ? 'Data sent successfully' : 'Failed to send data';
  //     });
  //   });
  // }

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockCubit, ClockStates>(
      builder: (context, state) {
        ClockCubit clockCubit = ClockCubit.get(context);

        return Scaffold(
          backgroundColor: const Color(0xff2d2f41),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff2d2f41),
            title: const Text(
              'Bluetooth Devices',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            actions: [
              clockCubit.isDiscovering
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: clockCubit.startDiscovery,
                    )
            ],
          ),
          body: Column(
            children: [
              if (clockCubit.connectionStatus != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    clockCubit.connectionStatus!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: clockCubit.devices.length,
                  itemBuilder: (context, index) {
                    BluetoothDevice device = clockCubit.devices[index].device;
                    bool isConnected =
                        device.name == clockCubit.connectedDeviceName;
                    return Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 57, 70, 121),
                      ),
                      child: ListTile(
                        title: Text(
                          device.name ?? 'Unknown Device',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          device.address,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: MaterialButton(
                          clipBehavior: Clip.antiAlias,
                          color: isConnected
                              ? Colors.green
                              : const Color(0xff748EF6),
                          onPressed: () => clockCubit.connectToDevice(
                              device.name ?? 'Unknown Device', device.address),
                          shape: const StadiumBorder(),
                          child: Text(
                            isConnected ? 'Connected' : 'Connect',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () => clockCubit.connectToDevice(
                            device.name ?? 'Unknown Device', device.address),
                      ),
                    );
                  },
                ),
              ),
              if (clockCubit.connectedDeviceName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          decoration: const InputDecoration(
                            labelText: 'Send Data',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          clockCubit.sendData(textController.text);
                          textController.clear();
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
