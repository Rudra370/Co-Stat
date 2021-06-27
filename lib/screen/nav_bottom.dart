import 'package:flutter/material.dart';
import 'package:rolling_nav_bar/rolling_nav_bar.dart';

import '../screen/search_country.dart';
import '../screen/worldwide_screen.dart';
import './home.dart';

class NavBottom extends StatefulWidget {
  @override
  _NavBottomState createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  final pages = [Home(), WorldWide(), SearchCountry()];

  var _index = 0;

  void _onTap(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: RollingNavBar.iconData(
          activeBadgeColors: <Color>[
            Theme.of(context).primaryColor,
          ],
          indicatorColors: [
            Colors.white,
          ],
          iconColors: [Colors.white],
          navBarDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          iconData: <IconData>[
            Icons.home,
            Icons.public,
            Icons.search,
          ],
          activeIconColors: <Color>[
            Theme.of(context).primaryColor,
          ],
          baseAnimationSpeed: 300,
          animationCurve: Curves.linear,
          onTap: _onTap,
          activeIndex: 0,
          animationType: AnimationType.roll,
        ),
      ),
    );
  }
}
