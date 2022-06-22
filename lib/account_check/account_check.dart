import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountCheck extends StatelessWidget {

  final bool login;
  final VoidCallback press;

  AccountCheck({
    required this.login,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have Account?" : "Already have Account?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Create Account" : "Log In",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
