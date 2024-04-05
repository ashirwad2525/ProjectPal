import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:collab3/screen/lets.dart';
import 'package:collab3/screen/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reenterPasswordController = TextEditingController();
  TextEditingController githubController = TextEditingController();
  TextEditingController linkedInController = TextEditingController();
  TextEditingController adminController = TextEditingController();

  bool isFirstNameValid = false;
  bool isLastNameValid = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isReenterPasswordValid = false;
  bool isGithubValid = false;
  bool isLinkedInValid = false;
  bool isAdmin = false; // Corrected

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/signin.jpg'),
    fit: BoxFit.cover, // Cover the entire background
    ),
    ),
    child: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
    // First Name, Last Name, and Email fields
    Column(
    children: [
    Row(
    children: [
    Expanded(
    child: Padding(
    padding: const EdgeInsets.only(right: 9),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.5),
    borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextField(
    controller: firstNameController,
    onChanged: (value) {
    setState(() {
    isFirstNameValid = value.isNotEmpty;
    });
    },
    decoration: InputDecoration(
    labelText: 'First Name',
    border: InputBorder.none,
    ),
    ),
    ),
    ),
    ),
    ),
    Expanded(
    child: Padding(
    padding: const EdgeInsets.only(left: 5, right: 5),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.5),
    borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextField(
    controller: lastNameController,
    onChanged: (value) {
    setState(() {
    isLastNameValid = value.isNotEmpty;
    });
    },
    decoration: InputDecoration(
    labelText: 'Last Name',
    border: InputBorder.none,
    ),
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    SizedBox(height: 10),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.5),
    borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextField(
    controller: emailController,
    onChanged: (value) {
    setState(() {
    isEmailValid = value.isNotEmpty;
    });
    },
    decoration: InputDecoration(
    labelText: 'Email',
    border: InputBorder.none,
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    SizedBox(height: 10),
    // Github Link field
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.5),
    borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextField(
    controller: githubController,
    onChanged: (value) {
    setState(() {
    isGithubValid = value.isNotEmpty;
    });
    },
    decoration: InputDecoration(
    labelText: 'Github Link',
    border: InputBorder.none,
    ),
    ),
    ),
    ),
    ),
    SizedBox(height: 10),
    // LinkedIn Link field
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.5),
    borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextField(
    controller: linkedInController,
    onChanged: (value) {
    setState(() {
    isLinkedInValid = value.isNotEmpty;
    });
    },
    decoration: InputDecoration(
    labelText: 'LinkedIn Link',
    border: InputBorder.none,
    ),
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.5),
    borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextField(
    controller: adminController,
    onChanged: (value) {
    setState(() {
    isAdmin = value.isNotEmpty;
    });
    },
    decoration: InputDecoration(
    labelText: 'Signup as Admin',
      border: InputBorder.none,
    ),
    ),
    ),
    ),
    ),
      SizedBox(height: 10),
      // Password field
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: passwordController,
              onChanged: (value) {
                setState(() {
                  isPasswordValid = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Password',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 10),
      // Re-enter Password field
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: reenterPasswordController,
              onChanged: (value) {
                setState(() {
                  isReenterPasswordValid = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Re-enter Password',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () async {
          if (isFirstNameValid &&
              isLastNameValid &&
              isEmailValid &&
              isPasswordValid &&
              isReenterPasswordValid &&
              isGithubValid &&
              isLinkedInValid) {
            // Register user with email and password
            try {
              // Create user in Firebase Auth
              UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
              // Store additional user data in Firestore
              await _firestore.collection('users').doc(userCredential.user!.uid).set({
                'firstName': firstNameController.text.trim(),
                'lastName': lastNameController.text.trim(),
                'email': emailController.text.trim(),
                'github': githubController.text.trim(),
                'linkedIn': linkedInController.text.trim(),
                'isAdmin': isAdmin, // Include admin status
              });
              // Navigate to next screen after successful registration
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Lets()),
              );
            } catch (e) {
              // Handle errors
              print("Error: $e");
            }
          } else {
            // Show error message or handle invalid input
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          'Next',
          style: TextStyle(color: Colors.black),
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
