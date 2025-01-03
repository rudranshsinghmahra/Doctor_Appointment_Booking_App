import 'dart:async';
import 'package:doctor_appointment_booking_app/services/log_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/firebase_authentication.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyApA_dL_JuPltpJsPhXQxLyBAad1Ag9jZ0",
      appId: "1:599843032180:android:2e4e7f7039d6f3ccd51521",
      messagingSenderId: "599843032180",
      projectId: "doctor-appointment-booki-9cff2",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => FirebaseAuthentication(),
      child: const MaterialApp(
        home: LogIn(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
