import 'package:flutter/material.dart';

import '../widget/data_display.dart';

class WorldWide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DataDisplay(country: 'World'),
    );
  }
}
