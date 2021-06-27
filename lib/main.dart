import './screen/spalsh_screen.dart';
import './service/api_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Api(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Covid Tracker',
          theme: ThemeData(
            primaryColor: Color(0xff24163d),
            accentColor: Color(0xffa01a7d),
            backgroundColor: Color(0xff311B92),
            scaffoldBackgroundColor: Color(0xffffffff),
            primarySwatch: Colors.red,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              buttonColor: Color(0xff311847),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          home: SplashScreen()),
    );
  }
}
