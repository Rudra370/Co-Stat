import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DotList extends StatelessWidget {
  final Color color;
  final String text;

  const DotList({this.color, this.text});
  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: _deviceWidth * 0.03,
          width: _deviceWidth * 0.03,
          child: Container(
            color: color,
          ),
        ),
        SizedBox(
          width: _deviceWidth * 0.02,
        ),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.averiaGruesaLibre(
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        )
      ],
    );
  }
}
