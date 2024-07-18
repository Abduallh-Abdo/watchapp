import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchapp/cubits/clock_cubit.dart';
import 'package:watchapp/views/clock_page.dart';
import 'package:watchapp/views/stop_watch_page.dart';
import 'package:watchapp/views/timer_page.dart';
import 'package:watchapp/widgets/bottomNavBar.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ClockCubit()..checkPermissions(context),
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
    StopWatchPage(),
    TimerPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2d2f41),
      body: _pages[_currentIndex],
      bottomNavigationBar: BarButtoms(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
