import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbsetting/auth_service.dart';
import 'package:fbsetting/loginview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  String SelectedRole = "Patient";
  final TextEditingController categoryController =
      TextEditingController(); // Doctor's category
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController workingTimeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final AuthService _authService = AuthService();
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  void _handleSignup() async {
    try {
      final User? user = await _authService.signUp(
        _emailController.text,
        _passController.text,
      );

      if (user != null) {
        final userData = {
          'name': _nameController.text,
          'email': _emailController.text,
          'role': SelectedRole,
        };

        if (SelectedRole == 'Doctor') {
          userData['category'] = categoryController.text;
          userData['description'] = descriptionController.text;
          userData['services'] = servicesController.text;
          userData['workingTime'] = workingTimeController.text;
          userData['phoneNumber'] = phoneNumberController.text;
        }

        await users.add(userData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign up successful!"),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User Already Register"),
          ),
        );
      }
    } catch (error) {
      if (error is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User Already Register"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred during signup."),
          ),
        );
      }
    }
  }

  // void _handleSignup() async {
  //   // Call your AuthService to sign up the user
  //   final User? signupError =
  //       await _authService.signUp(_emailController.text, _passController.text);

  //   if (signupError == null) {
  //     try {
  //       Map<String, dynamic> userData = {
  //         'name': _nameController.text,
  //         'email': _emailController.text,
  //         'role': SelectedRole,
  //       };

  //       if (SelectedRole == 'Doctor') {
  //         userData['category'] = categoryController.text;
  //         userData['description'] = descriptionController.text;
  //         userData['services'] = servicesController.text;
  //         userData['workingTime'] = workingTimeController.text;
  //         userData['phoneNumber'] = phoneNumberController.text;
  //       }
  //       // Attempt to add user data to Firestore
  //       await users.add(userData);

  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Sign up successful!"),
  //       ));

  //       // Navigate to your home screen after a successful signup
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => LoginView()));
  //     } catch (error) {
  //       // Handle Firestore data adding error
  //       setState(() {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text("Signup successful, but data could not be saved."),
  //           ),
  //         );
  //       });
  //     }
  //   } else {
  //     // Display the signup error to the user
  //     setState(() {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Signup failed: "),
  //       ));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Sign Up"),
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: const Image(
                    image: AssetImage('assets/images/loginIcon.png')),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Form(
                    child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 90),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 40,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintText: "Enter Your Name",
                            labelText: "Name",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Colors.blue, width: 1.4))),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButton<String>(
                          value: SelectedRole,
                          onChanged: (value) {
                            setState(() {
                              SelectedRole = value!;
                            });
                          },
                          items: ['Patient', 'Doctor'].map((role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(role),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(height: 16.0),

                      if (SelectedRole == 'Doctor')
                        TextFormField(
                          controller: categoryController,
                          decoration: InputDecoration(
                              hintText: "Enter Your Catagory",
                              labelText: "Catagory",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 1.4))),
                        ),
                      SizedBox(height: 16.0),

                      if (SelectedRole == 'Doctor')
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                              hintText: "Enter Description",
                              labelText: "Description",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 1.4))),
                        ),
                      SizedBox(
                        height: 11,
                      ),

                      if (SelectedRole == 'Doctor')
                        TextFormField(
                          controller: servicesController,
                          decoration: InputDecoration(
                            hintText: "Enter Services",
                            labelText: "Services",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16.0),

                      if (SelectedRole == 'Doctor')
                        TextFormField(
                          controller: workingTimeController,
                          decoration: InputDecoration(
                            hintText: "Enter Working Time",
                            labelText: "Working Time",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16.0),

                      // Phone Number field (Only for Doctors)
                      if (SelectedRole == 'Doctor')
                        TextFormField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            hintText: "Enter Phone Number",
                            labelText: "Phone Number",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: "Enter Your Email",
                            labelText: "Email",
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.4))),
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      TextFormField(
                        controller: _passController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                            hintText: "Enter Your Password",
                            labelText: "Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {});

                                _obscurePassword = !_obscurePassword;
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Colors.blue, width: 1.4))),
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      SizedBox(
                        width: 400,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                            ),
                            onPressed: _handleSignup,
                            child: const Text("Sign Up")),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("You have an Account? "),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
              ),
            )
          ],
        ),
      )),
    );
  }
}
