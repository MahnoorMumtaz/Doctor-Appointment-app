// import 'package:flutter/material.dart';
// import 'package:fbsetting/Catagory.dart';
// import 'package:fbsetting/DoctorDetailScreen.dart';
// import 'package:fbsetting/Doctors.dart';

// class DoctorsInCatagory extends StatelessWidget {
//   final Category category;

//   DoctorsInCatagory({required this.category});

//   @override
//   Widget build(BuildContext context) {
//     List<Doctor> doctors = [
//       Doctor(
//         name: 'Dr. John Smith',
//         specialization: 'Cardiologist',
//         shortDescription:
//             'Experienced cardiologist with 10+ years of practice.',
//       ),
//       Doctor(
//         name: 'Dr. Emily Johnson',
//         specialization: 'Pediatrician',
//         shortDescription: 'Caring pediatrician for your child\'s health.',
//       ),
//       Doctor(
//         name: 'Dr. Lisa Davis',
//         specialization: 'Dermatologist',
//         shortDescription: 'Skin expert with a passion for healthy skin.',
//       ),
//       Doctor(
//         name: 'Dr. Michael Lee',
//         specialization: 'Orthopedic Surgeon',
//         shortDescription: 'Skilled surgeon specializing in orthopedics.',
//       ),
//       Doctor(
//         name: 'Dr. Sarah Adams',
//         specialization: 'Pediatrician',
//         shortDescription: 'Mental health expert with a compassionate approach.',
//       ),
//       Doctor(
//         name: 'Dr. James Wilson',
//         specialization: 'Orthopedic surgeon',
//         shortDescription: 'Eye care specialist dedicated to your vision.',
//       ),
//       Doctor(
//         name: 'Dr. Maria Garcia',
//         specialization: 'Gyanaecologist',
//         shortDescription:
//             'Women\'s health advocate with expertise in gynecology.',
//       ),
//       Doctor(
//         name: 'Dr. Robert Turner',
//         specialization: 'general physician',
//         shortDescription: 'Dental care professional for a bright smile.',
//       ),
//       Doctor(
//         name: 'Dr. Elizabeth Johnson',
//         specialization: 'cardiologist',
//         shortDescription:
//             'Neurology specialist for brain and nervous system disorders.',
//       ),
//       Doctor(
//         name: 'Dr. Thomas Brown',
//         specialization: 'Urologist',
//         shortDescription:
//             'Urology expert for urinary tract and related issues.',
//       ),
//       // General Physicians
//       Doctor(
//         name: 'Dr. Jane Anderson',
//         specialization: 'General Physician',
//         shortDescription: 'Your primary care doctor for overall health.',
//       ),
//       Doctor(
//         name: 'Dr. Richard Clark',
//         specialization: 'General Physician',
//         shortDescription: 'Committed to your general well-being.',
//       ),
//       Doctor(
//         name: 'Dr. Laura White',
//         specialization: 'General Physician',
//         shortDescription: 'Dedicated to family health care.',
//       ),
//       Doctor(
//         name: 'Dr. William Martin',
//         specialization: 'General Physician',
//         shortDescription: 'Experienced in internal medicine.',
//       ),
//       Doctor(
//         name: 'Dr. Linda Harris',
//         specialization: 'General Physician',
//         shortDescription: 'Caring for your health concerns.',
//       ),
//       // Nephrologists
//       Doctor(
//         name: 'Dr. Robert Smith',
//         specialization: 'Nephrologist',
//         shortDescription: 'Specialist in kidney diseases.',
//       ),
//       Doctor(
//         name: 'Dr. Susan Johnson',
//         specialization: 'Nephrologist',
//         shortDescription: 'Dialysis and kidney care expert.',
//       ),
//       Doctor(
//         name: 'Dr. Mark Wilson',
//         specialization: 'Nephrologist',
//         shortDescription: 'Kidney health is our priority.',
//       ),
//       Doctor(
//         name: 'Dr. Sandra Baker',
//         specialization: 'Nephrologist',
//         shortDescription: 'Expertise in renal diseases.',
//       ),
//       Doctor(
//         name: 'Dr. Michael Brown',
//         specialization: 'Nephrologist',
//         shortDescription: 'Renal care for a healthier life.',
//       ),
//     ];

//     // Filter the list of doctors by the selected category.
//     List<Doctor> doctorsInCategory = doctors
//         .where(
//           (doctor) => doctor.specialization == category.name,
//         )
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctors in ${category.name} Category'),
//         backgroundColor: Colors.blue, // Set app bar color to blue
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16.0),
//         color:
//             Colors.blue.withOpacity(0.1), // Set a light blue background color
//         child: ListView.builder(
//           itemCount: doctorsInCategory.length,
//           itemBuilder: (context, index) {
//             return Card(
//               elevation: 4.0,
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//               color: Colors.white, // Set the card background color to white
//               child: ListTile(
//                 contentPadding: EdgeInsets.all(16.0),
//                 leading: Icon(Icons.person, color: Colors.blue), // Leading icon
//                 title: Text(
//                   doctorsInCategory[index].name,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18.0,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 subtitle: Text(doctorsInCategory[index].shortDescription),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           DoctorDetailScreen(doctor: doctorsInCategory[index]),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
