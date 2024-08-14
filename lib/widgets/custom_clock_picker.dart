// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/cubits/clock_states.dart';

class CustomClockPicker extends StatelessWidget {
  // final void Function(TimeOfDay) onTimeSelected;

  const CustomClockPicker({
    super.key,
    //  required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockCubit, ClockStates>(
      builder: (context, state) {
        ClockCubit clockCubit = ClockCubit.get(context);

        return SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Hour',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          NumberPicker(
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.white),
                              ),
                            ),
                            value: clockCubit.selectedHourAlarm,
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
                              clockCubit.updateHourNumberPicker(value);
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
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.white),
                              ),
                            ),
                            value: clockCubit.selectedMinuteAlarm,
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
                              clockCubit.updateMinNumberPicker(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () => clockCubit.updateAMtimer(true),
                    //       child: Container(
                    //         width: 60,
                    //         margin: const EdgeInsets.symmetric(vertical: 10),
                    //         alignment: Alignment.center,
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         child: Text(
                    //           'AM',
                    //           style: TextStyle(
                    //             color: clockCubit.isAM
                    //                 ? const Color(0xff748EF6)
                    //                 : Colors.white,
                    //             fontSize: 25,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () => clockCubit.updateAMtimer(false),
                    //       child: Container(
                    //         margin: const EdgeInsets.symmetric(vertical: 10),
                    //         width: 60,
                    //         alignment: Alignment.center,
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         child: Text(
                    //           'PM',
                    //           style: TextStyle(
                    //             color: clockCubit.isAM
                    //                 ? Colors.white
                    //                 : const Color(0xff748EF6),
                    //             fontSize: 25,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: const Color(0xff748EF6),
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
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: const Color(0xff748EF6),
                      onPressed: () {
                        TimeOfDay selectedClock = TimeOfDay(
                            hour: clockCubit.selectedHourAlarm,
                            minute: clockCubit.selectedMinuteAlarm);
                        print(
                            'Selected time: ${selectedClock.format(context)}'); // Debug statement
                        Navigator.of(context).pop(selectedClock);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
