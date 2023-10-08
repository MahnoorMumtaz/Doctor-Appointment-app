// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fbsetting/AppointmentForm.dart';
// import 'package:fbsetting/DoctorProfilePage.dart';
// import 'package:fbsetting/doctorappointmentaccepted.dart';
// import 'package:fbsetting/loginview.dart';

// class DoctorDetails extends StatefulWidget {
//   final String currentUserId; // Add a field to store the current user's ID

//   DoctorDetails({
//     required this.currentUserId,
//   });
//   @override
//   _DoctorDetailsState createState() => _DoctorDetailsState();
// }

// class _DoctorDetailsState extends State<DoctorDetails> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // Function to handle user logout
//   void _handleLogout() async {
//     await _auth.signOut();
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => LoginView(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User? user = _auth.currentUser;
//     // final String? currentUserId = user?.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctor Detail Page'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: _handleLogout,
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: Text('Doctor Appointment Accepted'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DoctorAppointmentAccepted(),
//                   ),
//                 );
//               },
//             ),
//             // Add other drawer items as needed
//           ],
//         ),
//       ),
//       // Rest of your code remains the same
//       body: StreamBuilder(
//         stream: firestore
//             .collection('users')
//             .doc(widget.currentUserId).
//                 where('role', isEqualTo: 'Doctor')
//           // Assuming doctors are stored in a subcollection
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           var doctorData = snapshot.data?.docs;

//           return ListView.builder(
//             itemCount: doctorData?.length,
//             itemBuilder: (context, index) {
//               var doctor = doctorData?[index].data() as Map<String, dynamic>;

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DoctorProfilePage(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(16.0),
//                   color: Colors.blue.withOpacity(0.1),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Doctor's name and avatar
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             radius: 40.0,
//                             backgroundImage: AssetImage(
//                                 'assets/doctor_avatar.png'), // You can replace with the actual avatar image
//                           ),
//                           SizedBox(width: 16.0),
//                           Text(
//                             doctor['name'],
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18.0,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20.0),

//                       // About details
//                       Text(
//                         'About',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5.0),
//                       Text(
//                         doctor['description'],
//                         style: TextStyle(
//                           fontSize: 14.0,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       SizedBox(height: 20.0),

//                       // Working time
//                       Text(
//                         doctor['workingTime'],
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 20.0),

//                       // Services
//                       Text(
//                         'Services',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5.0),
//                       Text(
//                         doctor['services'],
//                         style: TextStyle(
//                           fontSize: 14.0,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       SizedBox(height: 20.0),

//                       // Phone number
//                       Text(
//                         'Phone Number',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5.0),
//                       Text(
//                         doctor['phoneNumber'],
//                         style: TextStyle(
//                           fontSize: 14.0,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       SizedBox(height: 40.0),

//                       // Button for booking an appointment
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Add your appointment booking logic here
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(
//                             //     builder: (context) => AppointmentForm(
//                             //       doctorId: doctorData![index].id,
//                             //       patientId: currentUserId,
//                             //       useremail: doctor['email'],
//                             //       username: doctor['name'],
//                             //       usercategory: doctor['category'],
//                             //     ),
//                             //   ),
//                             // );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: Colors.blue,
//                             padding: EdgeInsets.symmetric(horizontal: 20.0),
//                           ),
//                           child: Text(
//                             'Book an Appointment',
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
