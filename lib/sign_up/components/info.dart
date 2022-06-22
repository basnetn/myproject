import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photogram/account_check/account_check.dart';
import 'package:photogram/home_screen/home_screen.dart';
import 'package:photogram/log_in/login_screen.dart';
import 'package:photogram/widgets/button_square.dart';
import 'package:photogram/widgets/input_field.dart';

class Credentials extends StatefulWidget {

  @override
  State<Credentials> createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  final TextEditingController _emailTextController = TextEditingController(text: '');
  final TextEditingController _passTextController = TextEditingController(text: '');
  final TextEditingController _fullNameController = TextEditingController(text: '');
  final TextEditingController _phoneNumController = TextEditingController(text: '');


  File? imageFile;
  String? imageUrl;

  void _showImageDialog() {
    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            title: Text("Please choose an option",
              style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w300,
                  color: Colors.white
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '  Camera',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '  Gallery',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath:
    filePath, maxHeight: 1080, maxWidth: 1080);

    if(croppedImage != null)
    {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()
            {
              _showImageDialog();
            },
            child:  CircleAvatar(
              radius: 80,
              backgroundImage: imageFile == null
                  ?
              const AssetImage('images/avatar.png')
                  :
              Image.file(imageFile!).image,
            ),
          ),
          const SizedBox(height: 10),
          InputField(
            hintText: "Enter Username",
            icon: Icons.person,
            obscureText: false,
            textEditingController: _fullNameController,
          ),
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
          InputField(
            hintText: "Enter Phone Number",
            icon: Icons.phone,
            obscureText: false,
            textEditingController: _phoneNumController,
          ),
          const SizedBox(height: 15),
          ButtonSquare(
            text: "Create Account",
            color1: Colors.blue,
            color2: Colors.blueAccent,
            press: () async {
              if(imageFile == null) {
                Fluttertoast.showToast(msg: "Please select an image");
                return;
              }
              try {
                final ref = FirebaseStorage.instance.ref().child("userImages").child('${DateTime.now()}.jpg');
                await ref.putFile(imageFile!);
                imageUrl = await ref.getDownloadURL();
                await _auth.createUserWithEmailAndPassword(
                  email: _emailTextController.text.trim().toLowerCase(),
                  password: _passTextController.text.trim(),
                );
                final User? user = _auth.currentUser;
                final _uid = user!.uid;
                FirebaseFirestore.instance.collection('users').doc(_uid).set({
                  'id': _uid,
                  'userImage': imageUrl,
                  'name': _fullNameController.text,
                  'email': _emailTextController.text,
                  'phoneNumber': _phoneNumController.text,
                  'createdAt': Timestamp.now(),
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              } catch (error) {
                Fluttertoast.showToast(msg: error.toString());
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
            },
          ),
          AccountCheck(
              login: false,
              press: ()
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              }
          )
        ],
      ),
    );
  }
}
