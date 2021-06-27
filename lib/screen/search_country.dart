import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/data_display.dart';
import '../helper/data_search.dart';

class SearchCountry extends StatefulWidget {
  @override
  _SearchCountryState createState() => _SearchCountryState();
}

class _SearchCountryState extends State<SearchCountry> {
  String country = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(country == '' ? 'Search' : country,
            style: GoogleFonts.averiaSerifLibre(
                fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch())
                  .then((value) {
                if (value != null) {
                  setState(() {
                    country = value;
                  });
                }
              });
            },
          )
        ],
      ),
      body: country == ''
          ? Center(
              child: Text('Search country'),
            )
          : DataDisplay(
              country: country,
              isSearched: true,
            ),
    );
  }
}
