import 'package:fbsetting/loginview.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorHomePage extends StatefulWidget {
  final String userEmail; // Add this line to accept user's email
  final String currentUserId; // Add a field to store the current user's ID
  DoctorHomePage({required this.currentUserId, required this.userEmail});
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to handle user logout
  void _handleLogout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginView(),
      ),
    );
  }

  Future<void> _acceptAppointment(String appointmentId) async {
    try {
      // Update the appointment status to "Accepted" in Firestore
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'Accepted'});

      // Show a snack bar for accepted appointment
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment accepted.'),
        ),
      );
    } catch (e) {
      // Handle errors, e.g., Firestore update errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting appointment: $e'),
        ),
      );
    }
  }

  Future<void> _rejectAppointment(String appointmentId) async {
    try {
      // Delete the appointment from Firestore
      await _firestore.collection('appointments').doc(appointmentId).delete();

      // Show a snack bar for rejected appointment
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment rejected.'),
        ),
      );
    } catch (e) {
      // Handle errors, e.g., Firestore delete errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting appointment: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<User?>(
          future: _auth.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data == null) {
              // User is not logged in
              return Text('You are not logged in.');
            }

            final User user = snapshot.data!;
            print("email" + widget.userEmail);
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('appointments')
                  .where('userEmail', isEqualTo: widget.userEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Center(child: Text('No Appointment Requests Found.'));
                }

                final appointmentRequests = snapshot.data!.docs;

                if (appointmentRequests.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(h)
                      Center(child: Text('No Appointment Requests Found.')),
                    ],
                  );
                }

                // Display the list of appointment requests
                return ListView.builder(
                  itemCount: appointmentRequests.length,
                  itemBuilder: (context, index) {
                    final appointmentRequest = appointmentRequests[index].data()
                        as Map<String, dynamic>;
                    final appointmentId = appointmentRequests[index].id;

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                            'Patient Name: ${appointmentRequest['patientName']}'),
                        subtitle: Text(
                            'Contact: ${appointmentRequest['patientContact']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Handle accepting the appointment
                                _acceptAppointment(appointmentId);
                              },
                              child: Text('Accept'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle rejecting the appointment
                                _rejectAppointment(appointmentId);
                              },
                              child: Text('Reject'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
