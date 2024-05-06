import 'package:chat_login/Sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/components/my_button.dart';
import '/components/my_textfield.dart';
import '/components/square_tile.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // sign user in method
  void signUserIn() async {
    // show loading circle
    if(formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // try sign in
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // pop the loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        Navigator.pop(context);
        // WRONG EMAIL
        if (e.code == 'user-not-found') {
          // show error to user
          wrongEmailMessage();
        }

        // WRONG PASSWORD
        else if (e.code == 'wrong-password') {
          // show error to user
          wrongPasswordMessage();
        }
      }
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Color.fromARGB(255, 150, 150, 150),
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Color.fromARGB(255, 176, 72, 72)),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    validator: (value) {
                      if (value
                          .toString()
                          .isEmpty) {
                        return 'Email is required';
                      }
                    }
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
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
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Text(
                  //         'Forgot Password?',
                  //         style: TextStyle(color: Colors.grey[600]),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                      onTap: signUserIn,
                      text: "Log In"
                  ),

                  const SizedBox(height: 50),

                  // or continue with
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

                  // google + apple sign in buttons
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: const [
                  //     // google button
                  //     SquareTile(imagePath: 'lib/images/google.png'),

                  //     SizedBox(width: 25),

                  //     // apple button
                  //     SquareTile(imagePath: 'lib/images/apple.png')
                  //   ],
                  // ),

                  // const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the login page when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupPage()),
                          );
                        },
                        child: const Text(
                          'Register Now',
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
          ),
        )
      ),
    );
  }
}