import 'package:flutter/material.dart';

import 'utils/session_manager.dart';
import 'views/common/list/moduleListView.dart';
import 'views/login_view.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    String session =await SessionManager.getSession();
    if (session.isNotEmpty) {
      isLoggedIn = true;
    }
    setState(() {
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child:
                CircularProgressIndicator(),
          ),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
        ? const ModuleListView( 
             moduleName: "Tasks",
          )
        : const LoginView(),
    );
  }
}