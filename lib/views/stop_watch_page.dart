import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/cubits/clock_states.dart';

class StopWatchPage extends StatelessWidget {
  const StopWatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockCubit, ClockStates>(
      builder: (context, state) {
        ClockCubit clockCubit = ClockCubit.get(context);
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
                      "Stop Watch",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Text(
                      "${clockCubit.digitHours}:${clockCubit.digitMinutes}:${clockCubit.digitSeconds}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF323F68),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView.builder(
                      itemCount: clockCubit.laps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lap ${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                clockCubit.laps[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: () {
                            (!clockCubit.startedStopWatch)
                                ? clockCubit.startStopWatch()
                                : clockCubit.stopStopWatch();
                          },
                          shape: const StadiumBorder(
                            side: BorderSide(color: Color(0xff748EF6)),
                          ),
                          child: Text(
                            (!clockCubit.startedStopWatch) ? "Start" : "Pause",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      IconButton(
                        color: Colors.white,
                        onPressed: () {
                          clockCubit.addLapsStopWatch();
                        },
                        icon: const Icon(
                          Icons.flag),
                      ),
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: () {
                            clockCubit.resetStopWatch();
                          },
                          fillColor: const Color(0xff748EF6),
                          shape: const StadiumBorder(),
                          child: const Text(
                            "Reset",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
