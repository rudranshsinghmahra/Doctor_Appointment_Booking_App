import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  CollectionReference doctors =
      FirebaseFirestore.instance.collection("doctors");

  Future updateOrderStatus(documentId, appointmentStatus) async {
    var result = await appointments.doc(documentId).update({
      'appointment_status': appointmentStatus,
    });
    return result;
  }
}
