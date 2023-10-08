import 'package:fbsetting/AppointmentForm.dart';
import 'package:flutter/material.dart';
import 'package:fbsetting/Doctors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:velocity_x/velocity_x.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String name;
  final String doctorId;
  final String patientId;
  final String useremail;

  final String usercategory;

  final String workingTime;
  final String services;
  final String phoneNumber;
  final String description;
  final String category;
  DoctorDetailScreen({
    required this.name,
    required this.doctorId,
    required this.workingTime,
    required this.services,
    required this.phoneNumber,
    required this.description,
    required this.category,
    required this.patientId,
    required this.useremail,
    required this.usercategory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 4,
          child: Container(
            height: 400,
            width: Get.width,
            padding: EdgeInsets.all(16.0),
            color: Colors.blue.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor's name and avatar
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      foregroundColor: Colors.transparent,
                      child: Image.asset('assets/images/profileimage.jpg'),
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5.0),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20.0),

                // Working time
                Text(
                  workingTime,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20.0),

                // Services
                Text(
                  services,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20.0),

                // Phone number
                Text(
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 40.0),

                // Button for booking an appointment
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentForm(
                              doctorId: doctorId,
                              patientId: patientId,
                              useremail: useremail,
                              username: name,
                              usercategory: category),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                    child: Text(
                      'Book an Appointment',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
