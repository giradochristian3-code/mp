import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'session_model.dart';
import 'login_page.dart';
import 'dashboard_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SessionModel()..loadSession(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Session Management - P11',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<SessionModel>(
        builder: (context, sessionModel, child) {
          if (sessionModel.isLoggedIn) {
            return DashboardPage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}