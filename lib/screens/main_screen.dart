import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_booking_app/screens/user_booking_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/auth_bloc.dart';
import '../main.dart';
import 'doctor_about_page.dart';
import 'doctor_details_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<User?>? loginStateSubscription;
  List<QueryDocumentSnapshot<Object?>>? document;
  String collectionName =
      FirebaseAuth.instance.currentUser?.displayName as String;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("1638542844521 RSM Gaming");

  fetchData() {}

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);

    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    final user = FirebaseAuth.instance.currentUser!;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(70, 212, 153, 0.8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(70, 212, 153, 0.0),
        actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: StreamBuilder<User?>(
          stream: authBloc.currentUser,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      snapshot.data!.displayName!,
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 25,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 20),
                    child: Text(
                      "Happy To See You",
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: size.width,
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          child: Text(
                            "Doctor's Specialization",
                            style: TextStyle(
                              color: Color(0xff363636),
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 120,
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        demoCategories("assets/images/cancer_1.png", "Cancer"),
                        demoCategories(
                            "assets/images/brain.png", "Male Health"),
                        demoCategories(
                            "assets/images/heart.png", "Female Health"),
                        demoCategories("assets/images/bone.png", "Health Care"),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width,
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          child: Text(
                            'Our Doctor',
                            style: TextStyle(
                              color: Color(0xff363636),
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: ListView(
                        children: [
                          demoTopRatedDr(
                            "assets/images/doctor_lata.png",
                            "Dr. Lata Grover",
                            "Homeopathic Doctor",
                            "4.8",
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName!),
              accountEmail: Text(user.email!),
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(70, 212, 153, 1)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color.fromRGBO(70, 212, 153, 1),
                backgroundImage: NetworkImage(user.photoURL!),
              ),
            ),
            ListTile(
              onTap: () {
                authBloc.logout();
              },
              leading: const Icon(Icons.logout),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                toggleDrawer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DoctorDetailPage()));
              },
              leading: Icon(Icons.add),
              title: Text(
                "Book Appointment",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                toggleDrawer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserBookingHistory()));
              },
              leading: Icon(Icons.logout),
              title: Text(
                "History",
                style: TextStyle(fontSize: 20),
              ),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (context) => ProfilePage()));
            //       },
            //       child: Text(
            //         "Profile",
            //         style: TextStyle(fontSize: 20),
            //       ),
            //     ),
            //     IconButton(
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => ProfilePage()));
            //         },
            //         icon: Icon(Icons.logout))
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget demoCategories(String img, String name) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Color(0xff107163),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(img),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget demoTopRatedDr(
    String img,
    String name,
    String speciality,
    String rating,
  ) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => docInfoPage()));
      },
      child: Container(
        height: 90,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              height: 90,
              width: 50,
              child: Image.asset(img),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          speciality,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: 3, left: size.width * 0.1),
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  "Rating: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  rating,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
