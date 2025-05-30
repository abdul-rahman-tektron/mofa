import 'package:flutter/material.dart';
import 'package:mofa/screens/apply_pass/apply_pass_screen.dart';
import 'package:mofa/screens/dashboard/dashboard_screen.dart';
import 'package:mofa/screens/search_pass/search_pass_screen.dart';

class BottomBarNotifier extends ChangeNotifier{
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  BottomBarNotifier(int? currentIndex) {
    _currentIndex = currentIndex ?? 0;
  }

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  final List<Widget> _screens = [
    DashboardScreen(),
    ApplyPassScreen(),
    SearchPassScreen(),
  ];

  Widget get currentScreen => _screens[_currentIndex];
}