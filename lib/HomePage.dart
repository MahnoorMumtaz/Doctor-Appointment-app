import 'package:fbsetting/AppointmentForm.dart';
import 'package:fbsetting/DoctorDetailScreen.dart';

import 'package:fbsetting/doctorappointmentaccepted.dart';
import 'package:fbsetting/doctordetailpage.dart';
import 'package:fbsetting/loginview.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final String currentUserId;
  final String userEmail;
  HomePage({required this.currentUserId, required this.userEmail});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function to handle user logout
  void _handleLogout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Doctors'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Doctor Appointment Accepted'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorAppointmentAccepted(),
                  ),
                );
              },
            ),
            // Add other drawer items as needed
          ],
        ),
      ),
      body: StreamBuilder(
        stream: firestore
            .collection('users')
            .where('role', isEqualTo: 'Doctor')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var doctorData = snapshot.data?.docs;

          return ListView.builder(
            itemCount: doctorData?.length,
            itemBuilder: (context, index) {
              var doctor = doctorData?[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailScreen(
                        name: doctor['name'],
                        workingTime: doctor['workingTime'],
                        services: doctor['services'],
                        phoneNumber: doctor['phoneNumber'],
                        description: doctor['description'],
                        category: doctor['category'],
                        useremail: doctor['email'],
                        doctorId: doctorData![index].id,
                        usercategory: doctor['category'],
                        patientId: widget.currentUserId,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.local_hospital, color: Colors.blue),
                    title: Text(doctor['name']),
                    subtitle: Text(doctor['category']),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
