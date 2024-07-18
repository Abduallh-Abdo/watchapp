import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/cubits/clock_states.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockCubit, ClockStates>(
      builder: (context, state) {
        ClockCubit clockCubit = ClockCubit.get(context);
        double progress = clockCubit.durationTimer.inSeconds == 0
            ? 0
            : clockCubit.remainingTimer.inSeconds /
                clockCubit.durationTimer.inSeconds;
        return Scaffold(
          backgroundColor: const Color(0xff2d2f41),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Timer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            clockCubit.selectTime(context);
                          },
                          child: CircularPercentIndicator(
                            radius: 110,
                            lineWidth: 8,
                            percent: progress,
                            progressColor: const Color(0xff748EF6),
                            circularStrokeCap: CircularStrokeCap.round,
                            animation: true,
                            center: clockCubit.selectedTime == null
                                ? const Text(
                                    "Select Time",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                    ),
                                  )
                                : Text(
                                    "${clockCubit.remainingTimer.inHours.toString().padLeft(2, '0')}:${(clockCubit.remainingTimer.inMinutes % 60).toString().padLeft(2, '0')}:${(clockCubit.remainingTimer.inSeconds % 60).toString().padLeft(2, '0')}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: () {
                            (!clockCubit.startedTimer)
                                ? clockCubit.startTimer()
                                : clockCubit.stopTimer();
                          },
                          shape: const StadiumBorder(
                            side: BorderSide(color: Color(0xff748EF6)),
                          ),
                          child: Text(
                            (!clockCubit.startedTimer) ? "Start" : "Pause",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: () {
                            clockCubit.resetTimer();
                          },
                          fillColor: const Color(0xff748EF6),
                          shape: const StadiumBorder(),
                          child: const Text(
                            "Reset",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  clockCubit.blueDevice.isConnected == true
                      ? Text(
                          clockCubit.connectionStatus!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        )
                      : Text(''),
                  // Text(
                  //   clockCubit.isConnected
                  //       ? 'Bluetooth Connected'
                  //       : 'Bluetooth Disconnected',
                  //   style: TextStyle(
                  //     color: clockCubit.isConnected ? Colors.green : Colors.red,
                  //     fontSize: 14.0,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
