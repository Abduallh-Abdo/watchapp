import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/cubits/clock_states.dart';
import 'package:watchapp/widgets/custom_show_alarm.dart';

class AlarmClockPage extends StatelessWidget {
  const AlarmClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockCubit, ClockStates>(
      builder: (context, state) {
        ClockCubit clockCubit = ClockCubit.get(context);

        return Scaffold(
          backgroundColor: const Color(0xff2d2f41),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Alarm Clock',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ConditionalBuilder(
                    condition: clockCubit.selectedClock != null,
                    fallback: (context) => Container(),
                    builder: (context) => Expanded(
                      child: ListView.builder(
                        itemCount: clockCubit.listAlarmClock.length,
                        itemBuilder: (context, index) {
                          final alarm = clockCubit.listAlarmClock[index];
                          return CustomShowAlarm(alarm: alarm);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff748EF6),
            onPressed: () {
              clockCubit.selectAlarmClock(context);
            },
            child: const Icon(
              Icons.alarm,
            ),
          ),
        );
      },
    );
  }
}
