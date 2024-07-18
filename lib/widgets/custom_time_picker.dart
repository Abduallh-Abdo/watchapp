import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;

  CustomTimePicker({required this.initialTime});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int selectedHour;
  late int selectedMinute;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hour;
    selectedMinute = widget.initialTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff2d2f41),
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
                child: DropdownButtonFormField<int>(
                  value: selectedHour,
                  dropdownColor: const Color(0xff2d2f41),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xff2d2f41),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  items: List.generate(24, (index) {
                    return DropdownMenuItem(
                      value: index,
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      selectedHour = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                ":",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: selectedMinute,
                  dropdownColor: const Color(0xff2d2f41),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xff2d2f41),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  items: List.generate(60, (index) {
                    return DropdownMenuItem(
                      value: index,
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      selectedMinute = value!;
                    });
                  },
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
        TextButton(
          onPressed: () {
            TimeOfDay selectedTime =
                TimeOfDay(hour: selectedHour, minute: selectedMinute);
            print('Selected time: ${selectedTime.format(context)}'); // Debug statement
            Navigator.of(context).pop(selectedTime);
          },
          child: const Text(
            'OK',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}