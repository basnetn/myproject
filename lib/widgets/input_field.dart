import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/widgets/input_field_container.dart';

class InputField extends StatelessWidget {

  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController textEditingController;

  InputField({
    required this.hintText,
    required this.icon,
    required this.obscureText,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          cursorColor: Colors.white,
          obscureText: obscureText,
          controller: textEditingController,
          decoration: InputDecoration(
              hintStyle:TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              hintText: hintText,
              helperStyle: const TextStyle(
                color: Colors.orange,
                fontSize: 18,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
              border: InputBorder.none
          ),
        ));
  }
}
