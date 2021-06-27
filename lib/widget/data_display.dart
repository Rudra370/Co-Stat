import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'card_widget.dart';

import '../service/api_service.dart';
import './pie_chart.dart';

class DataDisplay extends StatefulWidget {
  final String country;
  final bool isSearched;

  const DataDisplay({@required this.country, this.isSearched = false});
  @override
  _DataDisplayState createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {
  var isConnected = true;
  Future<void> _refresh() async {
    setState(() {
      init = true;
      loading = true;
      isConnected = true;
      didChangeDependencies();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  var init = true;
  var loading = true;
  var isSearched = false;
  Map<String, int> cases;
  List<String> todayCasesDeaths;
  List<String> testAndPerMillionData;
  List<String> casesAndDeathsMillionData;
  var country;
  @override
  Future<void> didChangeDependencies() async {
    print('dichange working');
    if (init && !widget.isSearched) {
      country = widget.country;
      if (widget.country == 'home') {
        country = await FlutterSecureStorage().read(key: 'country');
        setState(() {});
      }
      final api = Provider.of<Api>(context, listen: false);
      try {
        cases = await api.getCases(country: country);
        todayCasesDeaths = await api.getTodayCasesDeaths(country: country);
        testAndPerMillionData =
            await api.getTestAndTestPerMillion(country: country);
        casesAndDeathsMillionData =
            await api.getCasesAndDeathsPerMillion(country: country);
      } on SocketException catch (_) {
        setState(() {
          isConnected = false;
        });
        return;
      }
      setState(() {
        loading = false;
      });
    }
    if (isSearched) {
      final api = Provider.of<Api>(context, listen: false);
      cases = await api.getCases(country: widget.country);
      todayCasesDeaths = await api.getTodayCasesDeaths(country: widget.country);
      testAndPerMillionData =
          await api.getTestAndTestPerMillion(country: widget.country);
      casesAndDeathsMillionData =
          await api.getCasesAndDeathsPerMillion(country: widget.country);
      isSearched = false;
      setState(() {
        loading = false;
      });
    }
    super.didChangeDependencies();
  }

  final Color red = const Color(0xffFF3366);
  final Color blue = const Color(0xff645DD7);
  final Color green = const Color(0xff2ECC71);
  final Color white = const Color(0xffffffff);
  final Color yellow = const Color(0xffFEA82F);
  final Color darkGrey = const Color(0xff5D576B);
  final Color darkRed = const Color(0xffDB3A34);
  final Color pink = const Color(0xff62466B);

  @override
  Widget build(BuildContext context) {
    if (widget.isSearched) {
      isSearched = true;
      didChangeDependencies();
    }
    return Scaffold(
      appBar: widget.isSearched
          ? null
          : AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                  widget.country == 'home'
                      ? country.toUpperCase()
                      : widget.country.toUpperCase(),
                  style: GoogleFonts.lato(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2)),
            ),
      body: loading
          ? isConnected
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Fetching current data...')
                    ],
                  ),
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Could not connect to Internet'),
                    Text('Try Again !'),
                    IconButton(
                      onPressed: _refresh,
                      icon: Icon(Icons.refresh),
                    ),
                  ],
                ))
          : RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    PieChartWidget(cases: cases),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CardWidget(
                          backgroundColor: blue,
                          cases: todayCasesDeaths[0],
                          type: 'Today Cases',
                          dateString: todayCasesDeaths[2],
                        ),
                        CardWidget(
                          backgroundColor: red,
                          cases: todayCasesDeaths[1],
                          type: 'Today Deaths',
                          dateString: todayCasesDeaths[2],
                        ),
                      ],
                    ),
                    if (widget.country != 'World')
                      SizedBox(
                        height: 20,
                      ),
                    if (widget.country != 'World')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CardWidget(
                            backgroundColor: yellow,
                            cases: testAndPerMillionData[0],
                            type: 'Total Test',
                            dateString: testAndPerMillionData[2],
                          ),
                          CardWidget(
                            backgroundColor: darkGrey,
                            cases: testAndPerMillionData[1],
                            type: 'Test / Million',
                            dateString: testAndPerMillionData[2],
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CardWidget(
                          backgroundColor: pink,
                          cases: casesAndDeathsMillionData[0],
                          type: 'Cases / Million',
                          dateString: casesAndDeathsMillionData[2],
                        ),
                        CardWidget(
                          backgroundColor: darkRed,
                          cases: casesAndDeathsMillionData[1],
                          type: 'Deaths / Million',
                          dateString: casesAndDeathsMillionData[2],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
