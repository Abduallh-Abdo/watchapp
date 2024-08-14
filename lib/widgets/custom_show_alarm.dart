// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/cubits/clock_states.dart';
import 'package:watchapp/models/saved_alarm_clock.dart';

class CustomShowAlarm extends StatelessWidget {
  final SavedAlarmClock alarm;
  const CustomShowAlarm({
    super.key,
    required this.alarm,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockCubit, ClockStates>(
      builder: (context, state) {
        ClockCubit clockCubit = ClockCubit.get(context);
        return Container(
          margin: EdgeInsets.symmetric(
            // horizontal: 5,
            vertical: 10,
          ),
          alignment: Alignment.center,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: ListTile(
            title: Text(
              alarm.timeClock,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: alarm.isActiveClock,
                  onChanged: (value) {
                    clockCubit.updateDataAlarmClock(alarm.timeClock, value);
                  },
                  activeColor: const Color.fromARGB(255, 142, 167, 248),
                  inactiveThumbColor: const Color(0xff748EF6),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Color(0xff748EF6),
                  ),
                  onPressed: () {
                    clockCubit.removeDataAlarmClock(alarm.timeClock);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
