import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/views/alarm_clock_view.dart';
import 'package:watchapp/views/clock_page.dart';
import 'package:watchapp/views/stop_watch_page.dart';
import 'package:watchapp/views/timer_page.dart';
import 'package:watchapp/widgets/bottom_nav_bar.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ClockCubit()
        ..checkPermissions(context)
        ..getDataAlarmClock(),
      child: WatchApp(),
    ),
  );
}

class WatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    ClockPage(),
    const StopWatchPage(),
    const TimerPage(),
    const AlarmClockPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323F68),
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: BarButtoms(
          currentIndex: _currentIndex,
          onTabTapped: _onTabTapped,
        ),
      ),
    );
  }
}
