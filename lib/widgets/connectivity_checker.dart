import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityChecker extends StatefulWidget {
  const ConnectivityChecker({super.key});

  @override
  _ConnectivityCheckerState createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<List<ConnectivityResult>>(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context,
              AsyncSnapshot<List<ConnectivityResult>> snapshot) {
            if (snapshot.hasData && snapshot.data != ConnectivityResult.none) {
              return const Text("Connected");
            } else {
              return const Icon(
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
