import 'package:flutter/material.dart';

import 'main_screen.dart';

class SuccessfullyBooked extends StatefulWidget {
  const SuccessfullyBooked({Key? key, this.bookingStatus}) : super(key: key);
  final String? bookingStatus;

  @override
  _SuccessfullyBookedState createState() => _SuccessfullyBookedState();
}

class _SuccessfullyBookedState extends State<SuccessfullyBooked> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // color: Colors.green,
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.27,
              child: Image.asset("assets/images/success.gif"),
            ),
            Text(
              "Appointment ${widget.bookingStatus} ...",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: const Color.fromRGBO(70, 212, 153, 10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
