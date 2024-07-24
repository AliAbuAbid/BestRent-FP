// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

bool _isConnected = false;

class InternetCheckWidget extends StatefulWidget {
  @override
  _InternetCheckWidgetState createState() => _InternetCheckWidgetState();
}

class _InternetCheckWidgetState extends State<InternetCheckWidget> {
  @override
  void initState() {
    super.initState();
    _checkConnectivity(); // Check connectivity when the widget initializes
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InternetCheckWidget(),
  ));
}
