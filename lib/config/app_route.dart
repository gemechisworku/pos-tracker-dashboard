// ignore_for_file: no_duplicate_case_values, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:pos_tracker/screens/archives/archives_screen.dart';
import 'package:pos_tracker/screens/home/home_screen.dart';
import 'package:pos_tracker/screens/notifications/notifications_screen.dart';
import 'package:pos_tracker/screens/requests/requests_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('This is route: ${settings.name}');

    switch (settings.name) {
      case '/':
        return HomeScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case NotificationsScreen.routeName:
        return NotificationsScreen.route();
      case ArchivesScreen.routeName:
        return ArchivesScreen.route();
      // case RequestsScreen.routeName:
      //   return RequestsScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
                appBar: AppBar(
              title: Text('Error'),
            )));
  }
}
