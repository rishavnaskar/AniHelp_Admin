import 'package:flutter/material.dart';

class Components {
  Widget circularProgressIndicator() {
    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00a86b))));
  }
}
