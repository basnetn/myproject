import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photogram/account_check/account_check.dart';
import 'package:photogram/log_in/login_screen.dart';
import 'package:photogram/sign_up/signup_screen.dart';
import 'package:photogram/widgets/button_square.dart';
import 'package:photogram/widgets/input_field.dart';
import 'package:google_fonts/google_fonts.dart';

class Credentials extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailTextController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Center(
              child: Image.asset('images/forgetpassword.png',
                width: 250,
              ),
            ),
          ),
          const SizedBox(height: 10),
          InputField(
            hintText: "Enter Email",
            icon: Icons.email,
            obscureText: false,
            textEditingController: _emailTextController,
          ),
          const SizedBox(height: 15),
          ButtonSquare(
            text: "Send Link",
            color1: Colors.blue,
            color2: Colors.blueAccent,
            press: () async {
              try {
                await _auth.sendPasswordResetEmail(email: _emailTextController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.amber,
                    content: Text("Password reset email has been sent!",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ),
                );
              }
              on FirebaseAuthException catch(error) {
                Fluttertoast.showToast(msg:error.toString());
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },

          ),
          const SizedBox(height: 20),

          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
            },
            child: Center(child: Text('Create Account',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            ),
          ),
          AccountCheck(login: false,
              press: () async {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              }
          ),
        ],
      ),
    );
  }
}
