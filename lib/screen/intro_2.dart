import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import './spalsh_screen.dart';

class Intro2 extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  void _save(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    FlutterSecureStorage().write(key: 'first', value: 'false');
    _formKey.currentState.save();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SplashScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Form(
              key: _formKey,
              child: TextFormField(
                style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white,
                validator: (value) {
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please provide valid email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    labelText: 'Email',
                    labelStyle: GoogleFonts.sourceSansPro(
                        color: Colors.white, fontSize: 18)),
              ),
            )),
      ),
      floatingActionButton: DelayedDisplay(
        delay: Duration(seconds: 1),
        child: FlatButton(
          onPressed: () => _save(context),
          disabledTextColor: Colors.white70,
          textColor: Colors.white,
          child: Text(
            'Next',
          ),
        ),
      ),
    );
  }
}
