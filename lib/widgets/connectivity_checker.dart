import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityChecker extends StatefulWidget {
  const ConnectivityChecker({Key? key}) : super(key: key);

  @override
  _ConnectivityCheckerState createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context,
              AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot != null &&
                snapshot.hasData &&
                snapshot.data != ConnectivityResult.none) {
              return Text("Connected");
            } else {
              return Icon(
                Icons.wifi_off,
                size: 100,
              );
            }
          },
        ),
      ),
    );
  }
}
