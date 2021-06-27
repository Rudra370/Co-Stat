import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import './intro_1.dart';
import './nav_bottom.dart';
import '../service/api_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var error = false;
  var init = true;
  @override
  void didChangeDependencies() async {
    final storage = FlutterSecureStorage();
    final first = await storage.read(key: 'first');
    if (first == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Intro1(),
      ));
      return;
    }
    final expiry = await storage.read(key: 'expire');

    try {
      if (expiry != null) {
        final expiryTime = DateTime.parse(expiry);
        if (DateTime.now().isAfter(expiryTime)) {
          await Provider.of<Api>(context, listen: false).getAndSetToken();
        }
      } else {
        await Provider.of<Api>(context, listen: false).getAndSetToken();
      }
    } on SocketException catch (_) {
      setState(() {
        error = true;
      });
      return;
    } finally {
      init = false;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => NavBottom(),
      ),
    );
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.bottomLeft, colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor.withOpacity(0.8)
      ])),
      child: Center(
        child: error
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    color: Colors.white,
                    onPressed: () {
                      init = true;
                      setState(() {
                        error = false;
                        didChangeDependencies();
                      });
                    },
                  ),
                  Text(
                    'Could not connect to internet',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text('Try again', style: TextStyle(color: Colors.white))
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Accessing token for your device',
                      style: TextStyle(color: Colors.white))
                ],
              ),
      ),
    ));
  }
}
