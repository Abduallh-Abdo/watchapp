import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/cubits/clock_states.dart';

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockCubit, ClockStates>(
      builder: (context, state) {
        ClockCubit clockCubit = ClockCubit.get(context);
        return AlertDialog(
          backgroundColor: const Color(0xFF323F68),
          title: const Text(
            'Select Time',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Hour',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        NumberPicker(
                          value: clockCubit.selectedHourTimer,
                          minValue: 0,
                          maxValue: 23,
                          infiniteLoop: true,
                          zeroPad: true,
                          selectedTextStyle: const TextStyle(
                            fontSize: 30,
                            color: Color(0xff748EF6),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          onChanged: (value) {
                            clockCubit.upadateHourTimer(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    ":",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Minute',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        NumberPicker(
                          value: clockCubit.selectedMinuteTimer,
                          minValue: 0,
                          maxValue: 59,
                          infiniteLoop: true,
                          zeroPad: true,
                          selectedTextStyle: const TextStyle(
                            fontSize: 30,
                            color: Color(0xff748EF6),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          onChanged: (value) {
                            clockCubit.upadateMinTimer(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            TextButton(
              onPressed: () {
                TimeOfDay selectedTime = TimeOfDay(
                    hour: clockCubit.selectedHourTimer,
                    minute: clockCubit.selectedMinuteTimer);
                print(
                    'Selected time: ${selectedTime.format(context)}'); // Debug statement
                Navigator.of(context).pop(selectedTime);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        );
      },
    );
  }
}
