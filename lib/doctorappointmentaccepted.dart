import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointmentAccepted extends StatefulWidget {
  @override
  _DoctorAppointmentAcceptedState createState() =>
      _DoctorAppointmentAcceptedState();
}

class _DoctorAppointmentAcceptedState extends State<DoctorAppointmentAccepted> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Doctor Appointments'),
      ),
      body: StreamBuilder(
        stream: firestore
            .collection('appointments')
            .where('status', isEqualTo: 'Accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var acceptedAppointments = snapshot.data?.docs;

          if (acceptedAppointments!.isEmpty) {
            return Center(child: Text('No accepted appointments.'));
          }

          return ListView.builder(
            itemCount: acceptedAppointments.length,
            itemBuilder: (context, index) {
              var data =
                  acceptedAppointments[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['doctorname']),
                subtitle: Text(data['doctorcategory']),
                // You can add more details here
              );
            },
          );
        },
      ),
    );
  }
}
