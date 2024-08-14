import 'package:flutter/material.dart';

class BarButtoms extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const BarButtoms({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 40,
      currentIndex: currentIndex,
      backgroundColor: const Color(0xff2d2f41),
      elevation: 0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      selectedFontSize: 14.0,
      unselectedFontSize: 12.0,
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: currentIndex == 0
              ? Image.asset(
                  'assets/images/clock.png',
                  color: Colors.white,
                  scale: 0.8,
                )
              : Image.asset(
                  'assets/images/clock.png',
                  color: Colors.white54,
                ),
          label: 'Clock',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 1
              ? Image.asset(
                  'assets/images/stopwatch.png',
                  color: Colors.white,
                  scale: 0.8,
                )
              : Image.asset(
                  'assets/images/stopwatch.png',
                  color: Colors.white54,
                ),
          label: 'Stop Watch',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 2
              ? Image.asset(
                  'assets/images/timer.png',
                  color: Colors.white,
                  scale: 0.8,
                )
              : Image.asset(
                  'assets/images/timer.png',
                  color: Colors.white54,
                ),
          label: 'Timer',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 3
              ? Image.asset(
                  'assets/images/circular-alarm-clock-32.png',
                  color: Colors.white,
                  scale: 0.8,
                )
              : Image.asset(
                  'assets/images/circular-alarm-clock-32.png',
                  color: Colors.white54,
                ),
          label: 'Alarm',
        ),
      ],
    );
  }
}
