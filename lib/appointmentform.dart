import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbsetting/AppointmentForm.dart';
import 'package:fbsetting/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentForm extends StatefulWidget {
  final String doctorId;
  final String patientId;
  final String useremail;
  final String username;
  final String usercategory;
  AppointmentForm(
      {required this.doctorId,
      required this.patientId,
      required this.useremail,
      required this.username,
      required this.usercategory});

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentFormState createState() => _AppointmentFormState(
      doctorId, patientId, useremail, username, usercategory);
}

class _AppointmentFormState extends State<AppointmentForm> {
  final String doctorId;
  final String patientId;
  final String username;
  final String usercategory;

  String useremail;
  _AppointmentFormState(this.doctorId, this.patientId, this.useremail,
      this.username, this.usercategory);
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController patientContactController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  void _submitAppointment() async {
    final String doctorId = widget.doctorId;
    final String patientName = patientNameController.text;
    final String patientContact = patientContactController.text;
    final DateTime appointmentDate = selectedDate ?? DateTime.now();
    final String patientId = widget.patientId;

    final currentUser = FirebaseAuth.instance.currentUser;

    final Appointment appointment = Appointment(
      doctorId: doctorId,
      patientName: patientName,
      patientContact: patientContact,
      appointmentDate: appointmentDate,
      patientId: patientId,
      userEmail: widget.useremail,
      username: widget.username,
      usercategory: usercategory,
    );

    try {
      final CollectionReference appointments =
          FirebaseFirestore.instance.collection('appointments');

      await appointments.add(appointment.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Appointment submitted successfully!"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error submitting appointment: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Form'),
        backgroundColor: Colors.blue, // Set the app bar color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              child: Text(
                'Patient Information',
                style: TextStyle(
                    fontSize: 27,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: patientNameController,
              decoration: InputDecoration(
                  hintText: "Enter Your Name",
                  labelText: "Name",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.blue, width: 1.4))),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: patientContactController,
              decoration: InputDecoration(
                  hintText: "Enter Your Contact No",
                  labelText: "Number",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.blue, width: 1.4))),
            ),
            SizedBox(height: 29),
            Align(
              child: Text(
                'Appointment Details',
                style: TextStyle(
                    fontSize: 27,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Date: ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                      : 'Select Date',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: timeController,
              decoration: InputDecoration(
                  hintText: "Time(HH MM)",
                  labelText: "Time(HH MM)",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.blue, width: 1.4))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAppointment,
              child: Text('Submit Appointment'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Set button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Appointment {
  final String doctorId;
  final String patientName;
  final String patientContact;
  final DateTime appointmentDate;
  final String patientId;
  final String userEmail;
  final String username;
  final String usercategory;
  Appointment({
    required this.doctorId,
    required this.patientName,
    required this.patientContact,
    required this.appointmentDate,
    required this.patientId,
    required this.userEmail,
    required this.username,
    required this.usercategory,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientName': patientName,
      'patientContact': patientContact,
      'appointmentDate': appointmentDate.toString(),
      'patientId': patientId.toString(),
      'userEmail': userEmail,
      'doctorname': username,
      'doctorcategory': usercategory,
    };
  }
}
