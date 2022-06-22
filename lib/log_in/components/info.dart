import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/account_check/account_check.dart';
import 'package:photogram/forget_password/forget_password_screen.dart';
import 'package:photogram/home_screen/home_screen.dart';
import 'package:photogram/sign_up/signup_screen.dart';
import 'package:photogram/widgets/button_square.dart';
import 'package:photogram/widgets/input_field.dart';

class Credentials extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailTextController = TextEditingController(text: '');
  final TextEditingController _passTextController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: const AssetImage(
                  "images/logo.png"
              ),
              backgroundColor: Colors.deepPurpleAccent.shade700,
            ),
          ),
          const SizedBox(height: 15),
          InputField(

            hintText: "Enter Email",
            icon: Icons.email,
            obscureText: false,
            textEditingController: _emailTextController,

          ),
          InputField(
            hintText: "Enter Password",
            icon: Icons.lock,
            obscureText: true,
            textEditingController: _passTextController,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen()));
                },
                child: Text(
                  'Forget Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              )
            ],
          ),
          ButtonSquare(
            text: "Login",
            color1: Colors.blue,
            color2: Colors.blueAccent,

            press: () async {
              try {
                await _auth.signInWithEmailAndPassword(
                  email: _emailTextController.text.trim().toLowerCase(),
                  password: _passTextController.text.trim(),
                );
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
              } catch (error) {
                Fluttertoast.showToast(msg: error.toString());
              }
            },
          ),
          AccountCheck(
              login: true,
              press: ()
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
              }
          )
        ],

      ),
    );
  }
}
