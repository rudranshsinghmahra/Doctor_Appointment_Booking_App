import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_booking_app/screens/user_booking_history.dart';
import 'package:doctor_appointment_booking_app/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/auth_bloc.dart';
import 'doctor_about_page.dart';
import 'home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<User?>? loginStateSubscription;
  FirebaseServices services = FirebaseServices();
  User? user = FirebaseAuth.instance.currentUser;

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
            builder: (context) => const HomePage(),
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
      backgroundColor: const Color.fromRGBO(70, 212, 153, 0.8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(70, 212, 153, 0.0),
        actions: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
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
              return const CircularProgressIndicator();
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      user.displayName.toString(),
                      style: const TextStyle(
                        color: Color(0xff363636),
                        fontSize: 25,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, left: 20),
                    child: const Text(
                      "Happy To See You",
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: size.width,
                    margin: const EdgeInsets.only(top: 20, left: 20),
                    child: Stack(
                      fit: StackFit.loose,
                      children: const [
                        Text(
                          "Doctor's Specialization",
                          style: TextStyle(
                            color: Color(0xff363636),
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 120,
                    margin: const EdgeInsets.only(top: 20, left: 20),
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
                    margin: const EdgeInsets.only(top: 20, left: 20),
                    child: Stack(
                      fit: StackFit.loose,
                      children: const [
                        Text(
                          'Our Doctor',
                          style: TextStyle(
                            color: Color(0xff363636),
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: services.doctors.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorAboutPage(
                                        name: document['doctor_name'],
                                        speciality:
                                            document['doctor_specialization'],
                                        profilePic:
                                            document['doctor_profile_picture'],
                                        doctorAbout: document['doctor_about'],
                                        doctorUid: document.id,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Image.network(
                                                document[
                                                    'doctor_profile_picture'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 8.0, bottom: 8),
                                                  child: Text(
                                                    document['doctor_name'],
                                                    style: const TextStyle(
                                                      color: Color(0xff363636),
                                                      fontSize: 17,
                                                      fontFamily: 'Roboto',
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.67,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          document[
                                                              'doctor_specialization'],
                                                          style: const TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight.w300,
                                                              fontSize: 14),
                                                        ),
                                                        SizedBox(
                                                          width: 80,
                                                          child: Row(
                                                            children: const [
                                                              Text(
                                                                "Rating",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 14,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                "4.8",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
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
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 17),
              ),
            ),
            ListTile(
              onTap: () {
                toggleDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserBookingHistory(),
                  ),
                );
              },
              leading: const Icon(Icons.history),
              title: const Text(
                "Appointment History",
                style: TextStyle(fontSize: 17),
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
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: const Color(0xff107163),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(img),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              name,
              style: const TextStyle(
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
}
