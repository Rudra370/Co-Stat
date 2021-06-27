import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardWidget extends StatelessWidget {
  final Color backgroundColor;
  final String cases;
  final String type;
  final String dateString;

  const CardWidget(
      {@required this.backgroundColor,
      @required this.cases,
      @required this.type,
      this.dateString});
  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _deviceHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: _deviceWidth * 0.45,
      height: _deviceHeight * 0.22,
      child: Card(
        color: backgroundColor,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                cases,
                style: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: _deviceWidth * 0.09,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                type,
                style: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: _deviceWidth * 0.05,
                    fontWeight: FontWeight.w900),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  dateString,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.grey[100],
                      fontSize: _deviceWidth * 0.032,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w900),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
