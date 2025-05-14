import 'package:flutter/material.dart';
import 'doctor_details_page.dart';

class DocInfoPage extends StatelessWidget {
  const DocInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'avenir',
      ),
      home: const DoctorAboutPage(),
    );
  }
}

class DoctorAboutPage extends StatefulWidget {
  const DoctorAboutPage(
      {super.key,
      this.name,
      this.speciality,
      this.profilePic,
      this.doctorAbout,
      this.doctorUid});
  final String? name;
  final String? speciality;
  final String? profilePic;
  final String? doctorAbout;
  final String? doctorUid;

  @override
  _DoctorAboutPageState createState() => _DoctorAboutPageState();
}

class _DoctorAboutPageState extends State<DoctorAboutPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(70, 212, 153, 1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(70, 212, 153, 1),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(280),
            child: AppBar(
              backgroundColor: const Color.fromRGBO(70, 212, 153, 1),
              title: Text("${widget.name}"),
              centerTitle: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: 250,
                  width: 250,
                  padding: const EdgeInsets.only(top: 90, bottom: 30),
                  child: Image.asset('assets/images/bg1.png'),
                ),
              ),
            ),
          ),
          body: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, -1.15),
                  end: Alignment(0, 0.1),
                  colors: [Colors.green, Colors.greenAccent],
                ),
              ),
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: Image.network(
                                widget.profilePic.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.name}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${widget.speciality}",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "About the Doctor",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.doctorAbout.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Available Time Slots",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          timeSlotWidget(
                              "SUN", "Consultation", "Sunday 9 am to 11.30 am"),
                          timeSlotWidget(
                              "MON", "Consultation", "Monday 10 am to 12.30 am"),
                          timeSlotWidget(
                              "TUE", "Consultation", "Monday 10 am to 12.30 am"),
                          timeSlotWidget(
                              "WED", "Consultation", "Wednesday 8 am to 12.30 pm"),
                          timeSlotWidget(
                              "THRU", "Consultation", "Wednesday 8 am to 12.30 pm"),
                          timeSlotWidget(
                              "FRI", "Consultation", "Friday 8 am to 1 am"),
                          timeSlotWidget(
                              "SAT", "Consultation", "Saturday 8 am to 1 am"),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: const Color(0xff107163),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorDetailPage(
                                        name: widget.name,
                                        speciality: widget.speciality,
                                        doctorId: widget.doctorUid,
                                        doctorProfilePicture: widget.profilePic,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "BOOK APPOINTMENT",
                                  style: TextStyle(fontSize: 20,color: Colors.white),
                                ),
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
          ),
        ),
      ),
    );
  }

  Container timeSlotWidget(String month, String slotType, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(70, 212, 153, 10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 90,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xff107163),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    month,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  slotType,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
