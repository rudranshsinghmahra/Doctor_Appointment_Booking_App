import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserBookingHistory extends StatefulWidget {
  const UserBookingHistory({Key? key}) : super(key: key);

  @override
  _UserBookingHistoryState createState() => _UserBookingHistoryState();
}

class _UserBookingHistoryState extends State<UserBookingHistory> {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("1638542844521 RSM Gaming");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(70, 212, 153, 0.8),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: collectionReference.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs
                        .map(
                          (e) => ListTile(
                            subtitle: Text(e["customerPhone"]),
                            title: Text(e["selectedTime"]),
                          ),
                        )
                        .toList(),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
