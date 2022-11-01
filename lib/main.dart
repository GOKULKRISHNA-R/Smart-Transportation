import 'dart:developer';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'Screens/home_page.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

int count = 0;

void getScannedResults() async {
  // log(DateTime.now().toString());
  final can =
      await WiFiScan.instance.canGetScannedResults(askPermissions: true);
  // log(can.toString());
  switch (can) {
    case CanGetScannedResults.yes:
      final accessPoints = await WiFiScan.instance.getScannedResults();
      // log(accessPoints.length.toString());
      for (var element in accessPoints) {
        // log(element.ssid);
        if (element.ssid == "Kongu_Wifi") {
          count++;
          if (count == 5) {
            log("NEED TO DETECT ");
            count = 0;
          }
          // log(count.toString());
        }
      }
      break;
    case CanGetScannedResults.notSupported:
      log("CanGetScannedResults.notSupported");
      break;
    case CanGetScannedResults.noLocationPermissionRequired:
      log("CanGetScannedResults.noLocationPermissionRequired");
      break;
    case CanGetScannedResults.noLocationPermissionDenied:
      log("CanGetScannedResults.noLocationPermissionDenied");
      break;
    case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
      log("CanGetScannedResults.noLocationPermissionUpgradeAccuracy");
      break;
    case CanGetScannedResults.noLocationServiceDisabled:
      log("CanGetScannedResults.noLocationServiceDisabled");
      break;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp();
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
  const int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(seconds: 5), helloAlarmID, getScannedResults);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnimatedSplashScreen(
          nextScreen: MyHomePage(),
          splash: Image.asset(
            "assets/bus.gif",
          ),
          splashIconSize: 1000,
          duration: 1000,
          splashTransition: SplashTransition.slideTransition,
          curve: Curves.fastOutSlowIn,
        ));
  }
}
