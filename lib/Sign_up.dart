import 'package:chat_login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/components/my_button.dart';
import '/components/my_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, Key? Key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> signUserUp() async {
    if(formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Check if user creation was successful
        if (userCredential.user != null) {
          // Add user details to Firestore
          await addUserDetails(
            firstController.text.trim(),
            passwordController.text.trim(),
            emailController.text.trim(),
            userCredential.user!
                .uid, // Pass the user's UID obtained from userCredential
          );

          // Navigate to login page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } catch (error) {
        print('Error signing up: $error');
        // Handle sign-up errors
        // Show error message to the user
      }
    }

  }

  Future<void> addUserDetails(String name, String password, String email, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'password': password,
      'email': email,
      'uid': uid,
      // Add more user details if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Sign up to chat DRDO ',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: firstController,
                    hintText: 'Enter first name',
                    obscureText: false,
                    validator: (value){
                      if (value.toString().isEmpty) {
                        return 'first name is required';
                      }else if(value.toString().length<4){
                        return 'first name Must be more than 4 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    validator: (value){
                if (value.toString().isEmpty) {
                return 'Email is required';
                }
                return null;
                //return "";
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    validator: (value){
                      RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      var passNonNullValue=value??"";
                      if(passNonNullValue.isEmpty){
                        return ("Password is required");
                      }
                      else if(passNonNullValue.length<7){
                        return ("Minimum 8 charater");
                      }
                      else if(!regex.hasMatch(passNonNullValue)){
                        return ("Atleast one A-Z, and 1a-z and and one symbol from @#/\$_&.,/");
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap: signUserUp,
                    text: 'Sign up',
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                       const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the login page when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'Log In Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
