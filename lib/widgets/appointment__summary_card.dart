import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_booking_app/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../screens/reschedule_appointment_screen.dart';

class AppointmentSummaryCard extends StatefulWidget {
  const AppointmentSummaryCard({Key? key, required this.documentSnapshot})
      : super(key: key);
  final DocumentSnapshot documentSnapshot;

  @override
  State<AppointmentSummaryCard> createState() => _AppointmentSummaryCardState();
}

class _AppointmentSummaryCardState extends State<AppointmentSummaryCard> {
  FirebaseServices services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.documentSnapshot['doctor']['doctorName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.documentSnapshot['doctor']
                              ['doctorSpecialization'],
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        color: Colors.white,
                        height: 50,
                        width: 50,
                        child: Image.network(
                          widget.documentSnapshot['doctor']
                              ['doctorProfilePicture'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.black26,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(widget.documentSnapshot['selectedDate'])
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.clock_fill,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(widget.documentSnapshot['selectedTime'])
                        ],
                      ),
                      Row(
                        children: [
                          widget.documentSnapshot['appointment_status'] ==
                                  "Completed"
                              ? const Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                )
                              : ClipOval(
                                  child: Container(
                                    color: widget.documentSnapshot[
                                                'appointment_status'] ==
                                            "Waiting Approval"
                                        ? Colors.amber
                                        : (widget.documentSnapshot[
                                                    'appointment_status'] ==
                                                "Rejected"
                                            ? Colors.red
                                            : (widget.documentSnapshot[
                                                        'appointment_status'] ==
                                                    "Cancelled"
                                                ? Colors.grey
                                                : Colors.green)),
                                    width: 8,
                                    height: 8,
                                  ),
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            // width: 80,
                            child: Text(
                              widget.documentSnapshot['appointment_status'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                widget.documentSnapshot['appointment_status'] == "Completed" ||
                        widget.documentSnapshot['appointment_status'] ==
                            "Cancelled" ||
                        widget.documentSnapshot['appointment_status'] ==
                            "Rejected"
                    ? Container()
                    : (widget.documentSnapshot['appointment_status'] ==
                            "Accepted"
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Appointment Accepted !\nPlease wait for the doctor's call and keep you previous test report in hand if available.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    onPressed: () {
                                      showCustomDialog(
                                          context, "Cancel", "Cancelled");
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 0,
                                      backgroundColor: const Color.fromRGBO(
                                          70, 212, 153, 0.8),
                                    ),
                                    onPressed: () {
                                      //TODO Rescheduling Appointment Function
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RescheduleAppointmentScreen(
                                            doctorName: widget
                                                    .documentSnapshot['doctor']
                                                ["doctorName"],
                                            doctorSpeciality: widget
                                                    .documentSnapshot['doctor']
                                                ["doctorSpecialization"],
                                            documentId:
                                                widget.documentSnapshot.id,
                                            doctorProfilePic: widget
                                                    .documentSnapshot['doctor']
                                                ['doctorProfilePicture'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                        top: 15,bottom: 15
                                      ),
                                      child: Text(
                                        "Reschedule",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  AwesomeDialog showCustomDialog(context, title, appointmentStatus) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.infoReverse,
      animType: AnimType.rightSlide,
      title: "$title Appointment",
      desc:
          'Do you really want to ${title.toString().toLowerCase()} your appointment ?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        services.updateOrderStatus(
            widget.documentSnapshot.id, appointmentStatus);
      },
    )..show();
  }
}
