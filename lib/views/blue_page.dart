import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/cubits/clock_states.dart';

class BluetoothPage extends StatelessWidget {
  final TextEditingController textController = TextEditingController();

  BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockCubit, ClockStates>(
      builder: (context, state) {
        ClockCubit clockCubit = ClockCubit.get(context);

        return Scaffold(
          backgroundColor: const Color(0xff2d2f41),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // centerTitle: true,
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
