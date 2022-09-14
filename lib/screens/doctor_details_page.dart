import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'confirmation_page.dart';

class DoctorDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetailPage> {
  DateTime? date;
  TimeOfDay? time;
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = "";
  bool loading = false;

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      return DateFormat('dd/MM/yyyy').format(date!);
    }
  }

  String getTimeText() {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time?.hour.toString().padLeft(2, '0');
      final minutes = time?.minute.toString().padLeft(2, '0');
      return '${hours}:${minutes}';
    }
  }

  Future<void> userSetup() async {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: const CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
    );

    String? user = FirebaseAuth.instance.currentUser?.displayName.toString();
    String docId = (DateTime.now().millisecondsSinceEpoch).toString();
    String collectionName = "$docId $user";
    final hours = time?.hour.toString().padLeft(2, '0');
    final minutes = time?.minute.toString().padLeft(2, '0');

    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collectionName);

    final player = AudioCache();

    if (phoneController.text.isEmpty || date == null || time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Error ! Field(s) are missing",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      await pr.show();
      await collectionReference.add({
        "customerId": FirebaseAuth.instance.currentUser?.uid.toString(),
        "customerName": FirebaseAuth.instance.currentUser?.displayName,
        "customerEmail": FirebaseAuth.instance.currentUser?.email,
        "customerPhone": phoneNumber,
        "selectedTime": '${hours}:${minutes}',
        "selectedDate": DateFormat('dd/MM/yyyy').format(date!),
      }).then((value) => phoneController.clear());
      // users.set({
      //   "customerId": FirebaseAuth.instance.currentUser?.uid.toString(),
      //   "customerName": FirebaseAuth.instance.currentUser?.displayName,
      //   "customerEmail": FirebaseAuth.instance.currentUser?.email,
      //   "customerPhone": phoneNumber,
      //   "selectedTime": '${hours}:${minutes}',
      //   "selectedDate": DateFormat('dd/MM/yyyy').format(date!),
      // });
      await pr.hide();
      player.play("notification.mp3");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Appointment Booked Successfully",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SuccessfullyBooked()));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot != null &&
            snapshot.hasData &&
            snapshot.data != ConnectivityResult.none) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: const Color.fromRGBO(70, 212, 153, 10),
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              actions: [
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: const Icon(
                      Icons.notifications_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(70, 212, 153, 1),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Image.asset(
                              "assets/images/doctor_lata.png",
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dr. Lata Grover',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: const Text(
                                    'Homeopathic Doctor',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: const Text(
                                    'Rating: 4.8',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 30),
                    child: const Text(
                      'Appointment Date',
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromRGBO(70, 212, 153, 0.8))),
                        onPressed: () => pickDate(context),
                        child: Text(
                          getText(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 30),
                    child: const Text(
                      'Appointment Time',
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromRGBO(70, 212, 153, 0.8))),
                        onPressed: () {
                          pickTime(context);
                        },
                        child: Text(
                          getTimeText(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 30),
                    child: const Text(
                      'Phone Number',
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      maxLength: 10,
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          child: Text(
                            " (+91) ",
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                        ),
                        prefixStyle: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        hintText: "Phone Number",
                        hintStyle: const TextStyle(
                          letterSpacing: 2,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        fillColor: const Color.fromRGBO(70, 212, 153, 0.8),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xff107163),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            loading = true;
                            phoneNumber = phoneController.text;
                          });
                          userSetup();
                        },
                        child: const Text(
                          "BOOK APPOINTMENT",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Icon(
                Icons.wifi_off,
                size: 100,
              ),
            ),
          );
        }
      },
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) {
      return;
    }
    setState(() {
      date = newDate;
    });
  }

  Future pickTime(BuildContext context) async {
    const initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
        context: context, initialTime: time ?? initialTime);
    if (newTime == null) {
      return;
    }
    setState(() {
      time = newTime;
    });
  }
}
