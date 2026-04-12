import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'pages/Home.dart';
import 'pages/profile pages/profile_screen.dart';
import 'pages/profile pages/updateprofile.dart';
import 'Log & Reg.dart';
import 'pages/contact us.dart';
import 'pages/about us.dart';
import 'pages/volunteer/volunteer_page.dart';
import 'pages/volunteer/vol_online.dart';
import 'pages/settings.dart';
import 'pages/customer/customer_offline.dart';
import 'pages/customer/customer_online.dart';
import 'pages/customer/customer_page.dart';
import 'pages/volunteer/volunteer_offline.dart';
import 'pages/add service.dart';
import 'pages/services.dart';

void main() {
  runApp(const MyApp());
}

const Color mainGreen = Color(0xFF1ABC9C);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: mainGreen,
      ),
      home:CustomerOnline(
          //serviceType: "Delivery"
          //isDark : isDark,
          //toggleTheme : toggleTheme
      ),
    );
  }
}


