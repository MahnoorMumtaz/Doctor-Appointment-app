import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbsetting/DoctorHomePage.dart';
import 'package:fbsetting/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fbsetting/HomePage.dart';
import 'package:fbsetting/SignUp.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;

  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _error = '';
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  void _handleSignIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Sign in the user using Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // User has successfully signed in, get their UID
        String currentUserId = user.uid;

        // Check if the user exists in the "users" collection
        bool userExists = await _authService.checkIfUserExists(email);

        if (userExists) {
          // The user exists in the "users" collection, you can proceed
          // Get the user's role from Firestore
          String? role = await _authService.getUserRole(email);

          if (role == 'Doctor') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorHomePage(
                  currentUserId: userCredential.user!.uid,
                  userEmail: email.toString(), // Pass the user's email
                ),
              ),
            );
          } else if (role == 'Patient') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  currentUserId: userCredential.user!.uid,
                  userEmail: email.toString(), // Pass the user's email
                ),
              ),
            );
          } else {
            // Handle unknown role
            // ...
          }
        } else {}
      }
    } catch (e) {
      // Handle sign-in errors here
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid Login Credentials"),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Login Page"),
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
                    padding: EdgeInsets.only(top: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 40,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                          controller: _passwordController,
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
                        SizedBox(
                          height: 10,
                        ),
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Text("Forget Password"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 400,
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                              ),
                              onPressed: _handleSignIn,
                              child: const Text("Login")),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an Account? "),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await Get.to(() => SignUp());
                                _emailController.clear(); // Clear email field
                                _passwordController
                                    .clear(); // Clear password field
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
