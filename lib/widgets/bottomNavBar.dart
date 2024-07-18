import 'package:flutter/material.dart';

class BarButtoms extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const BarButtoms({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 68, 75, 100), 
        borderRadius: BorderRadius.circular(150),
      ),
      margin: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: BottomNavigationBar(
          iconSize: 40,
          currentIndex: currentIndex,
          backgroundColor: Colors.transparent,
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
          ],
        ),
      ),
    );
  }
}
