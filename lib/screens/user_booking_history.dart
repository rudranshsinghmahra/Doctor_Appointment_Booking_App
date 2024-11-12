import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_booking_app/provider.dart';
import 'package:doctor_appointment_booking_app/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/appointment__summary_card.dart';

class UserBookingHistory extends StatefulWidget {
  const UserBookingHistory({Key? key}) : super(key: key);

  @override
  _UserBookingHistoryState createState() => _UserBookingHistoryState();
}

class _UserBookingHistoryState extends State<UserBookingHistory> {
  int tag = 0;
  List<String> options = [
    'All Appointments',
    'Waiting Approval',
    'Accepted',
    'Cancelled',
    'Rejected',
    'Completed',
  ];

  FirebaseServices services = FirebaseServices();
  OrderProvider orderProvider = OrderProvider();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(70, 212, 153, 0.8),
      ),
      body: Column(
        children: [
          ChipsChoice<int>.single(
            value: tag,
            onChanged: (val) {
              if (val == 0) {
                setState(() {
                  orderProvider.status == null;
                });
              }
              setState(() {
                tag = val;
                orderProvider.status = options[val];
              });
            },
            choiceItems: C2Choice.listFrom<int, String>(
              source: options,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
            choiceStyle: const C2ChipStyle(backgroundColor: Colors.green),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: services.appointments
                .where("customerId", isEqualTo: user?.uid)
                .where('appointment_status',
                    isEqualTo: tag == 0 ? null : orderProvider.status)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.data?.size == 0) {
                //TODO: No Appointments screen
                return Expanded(
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        tag > 0
                            ? "No ${options[tag]} Appointments"
                            : "No Appointments Currently",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: SizedBox(
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Color.fromRGBO(80, 212, 153, 1),
                    )),
                  ),
                );
              }
              return Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return AppointmentSummaryCard(
                      documentSnapshot: document,
                    );
                  }).toList(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
