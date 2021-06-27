import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import './dot_list.dart';
import '../widget/badge.dart';

class PieChartWidget extends StatefulWidget {
  final Map<String, int> cases;

  const PieChartWidget({this.cases});
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  var _touchedIndex = -1;
  final Color red = const Color(0xffFF3366);
  final Color blue = const Color(0xff645DD7);
  final Color green = const Color(0xff2ECC71);
  @override
  Widget build(BuildContext context) {
    final double _totalCase = widget.cases['total'] * 1.0;
    final double _recoveredCase = widget.cases['recovered'] * 1.0;
    final double _activeCase = widget.cases['active'] * 1.0;
    final double _totalDeaths = _totalCase - _recoveredCase - _activeCase;
    final double _recoveredPercent = (_recoveredCase / _totalCase) * 100;
    final double _activePercent = (_activeCase / _totalCase) * 100;
    final double _deathsPercent = (_totalDeaths / _totalCase) * 100;
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.only(
          top: _deviceWidth * 0.04, bottom: _deviceHeight * 0.01),
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 3,
                color: Theme.of(context).primaryColor,
                spreadRadius: 1,
                offset: Offset.fromDirection(10))
          ],
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: const Radius.circular(50),
            bottomRight: const Radius.circular(50),
          )),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: _deviceWidth * 0.75,
                height: _deviceHeight * 0.4,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 1,
                    centerSpaceRadius: 0,
                    pieTouchData: PieTouchData(
                      enabled: true,
                      touchCallback: (touchData) {
                        if (touchData.touchInput is FlLongPressEnd ||
                            touchData.touchInput is FlPanEnd) {
                          _touchedIndex = -1;
                        } else {
                          setState(() {
                            if (touchData.touchInput is FlTouchInput)
                              _touchedIndex = touchData.touchedSectionIndex;
                          });
                        }
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    startDegreeOffset: 30,
                    sections: <PieChartSectionData>[
                      PieChartSectionData(
                        titlePositionPercentageOffset: 0.45,
                        showTitle: _touchedIndex != 1 && _touchedIndex != 2,
                        value: _totalDeaths,
                        radius: _touchedIndex == 0
                            ? _deviceWidth * 0.33
                            : _deviceWidth * 0.3,
                        title: _touchedIndex == 0
                            ? _totalDeaths.toStringAsFixed(0)
                            : _deathsPercent.toStringAsFixed(2) + '%',
                        color: red,
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: _touchedIndex == 0
                              ? _deviceWidth * 0.05
                              : _deviceWidth * 0.04,
                          letterSpacing: _touchedIndex == 0 ? 1.3 : 1,
                          shadows: <Shadow>[
                            Shadow(
                              color: Colors.black.withOpacity(.3),
                              offset: const Offset(2, 2),
                              blurRadius: 3.5,
                            )
                          ],
                        ),
                        badgeWidget: Badge(
                          color: red,
                          path: 'assets/images/death.jpg',
                          size: _touchedIndex == 0
                              ? _deviceWidth * 0.08
                              : _deviceWidth * 0.06,
                        ),
                        badgePositionPercentageOffset: 1,
                      ),
                      PieChartSectionData(
                        titlePositionPercentageOffset: 0.5,
                        showTitle: _touchedIndex != 0 && _touchedIndex != 2,
                        value: _activeCase,
                        radius: _touchedIndex == 1
                            ? _deviceWidth * 0.33
                            : _deviceWidth * 0.3,
                        title: _touchedIndex == 1
                            ? _activeCase.toStringAsFixed(0)
                            : _activePercent.toStringAsFixed(2) + '%',
                        color: blue,
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: _touchedIndex == 1
                              ? _deviceWidth * 0.05
                              : _deviceWidth * 0.04,
                          letterSpacing: _touchedIndex == 1 ? 1.3 : 1,
                          shadows: <Shadow>[
                            Shadow(
                              color: Colors.black.withOpacity(.3),
                              offset: const Offset(2, 2),
                              blurRadius: 3.5,
                            )
                          ],
                        ),
                        badgeWidget: Badge(
                          color: blue,
                          path: 'assets/images/active.jpg',
                          size: _touchedIndex == 1
                              ? _deviceWidth * 0.08
                              : _deviceWidth * 0.06,
                        ),
                        badgePositionPercentageOffset: 1,
                      ),
                      PieChartSectionData(
                        titlePositionPercentageOffset: 0.5,
                        showTitle: _touchedIndex != 0 && _touchedIndex != 1,
                        value: widget.cases['recovered'] * 1.0,
                        radius: _touchedIndex == 2
                            ? _deviceWidth * 0.33
                            : _deviceWidth * 0.3,
                        title: _touchedIndex == 2
                            ? _recoveredCase.toStringAsFixed(0)
                            : _recoveredPercent.toStringAsFixed(2) + '%',
                        color: green,
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: _touchedIndex == 2
                              ? _deviceWidth * 0.05
                              : _deviceWidth * 0.04,
                          letterSpacing: _touchedIndex == 2 ? 1.3 : 1,
                          shadows: <Shadow>[
                            Shadow(
                              color: Colors.black.withOpacity(.3),
                              offset: const Offset(2, 2),
                              blurRadius: 3.5,
                            )
                          ],
                        ),
                        badgeWidget: Badge(
                          color: green,
                          path: 'assets/images/recovered.jpg',
                          size: _touchedIndex == 2
                              ? _deviceWidth * 0.08
                              : _deviceWidth * 0.06,
                        ),
                        badgePositionPercentageOffset: 1,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: _deviceWidth * 0.25,
                height: _deviceHeight * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    DotList(
                      color: green,
                      text: 'Recovered',
                    ),
                    DotList(
                      color: blue,
                      text: 'Active',
                    ),
                    DotList(
                      color: red,
                      text: 'Death',
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Total Cases : ' + _totalCase.toStringAsFixed(0),
            style: GoogleFonts.averiaGruesaLibre(
                color: Colors.white, fontSize: _deviceWidth * 0.048),
          )
        ],
      ),
    );
  }
}
