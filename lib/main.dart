import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paikart/ui/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'paikart',
      options: FirebaseOptions(
          apiKey: "AIzaSyBQkghuIbbFN9awWDj02FRwJIEfXn5EFXw",
          appId: "1:964878183075:android:fa989dc06fa286ac81ad16",
          messagingSenderId: "964878183075",
          authDomain:"paikart-e01ad.firebaseapp.com",
          databaseURL: "https://{paikart-e01ad}.firebaseio.com",
          projectId: "paikart-e01ad")
    ).whenComplete(() {
      print("completedAppInitialize");
    });
  }
  // await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //         apiKey: "AIzaSyBQkghuIbbFN9awWDj02FRwJIEfXn5EFXw",
  //         appId: "1:964878183075:android:fa989dc06fa286ac81ad16",
  //         messagingSenderId: "964878183075",
  //         authDomain:"paikart-e01ad.firebaseapp.com",
  //         databaseURL: "https://{paikart-e01ad}.firebaseio.com",
  //         projectId: "paikart-e01ad")
  // );
  runApp(
      MaterialApp(
        home: MyApp())
      );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: () {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter E-Commerce',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
