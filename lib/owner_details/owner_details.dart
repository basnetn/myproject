import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:photogram/home_screen/home_screen.dart';
import 'package:photogram/widgets/button_square.dart';

class OwnerDetails extends StatefulWidget {
  String? img;
  String? userImg;
  String? name;
  DateTime? date;
  String? docId;
  String? userId;
  int? downloads;

  OwnerDetails({
    this.img,
    this.userImg,
    this.name,
    this.date,
    this.docId,
    this.userId,
    this.downloads,
  });

  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  int? total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.deepPurple.shade300,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.2, 0.9],
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Image.network(
                        widget.img!,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Owner Information',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                          widget.userImg!,
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Uploaded by: ${widget.name!}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat("dd MMMM, yyyy - hh:mm a")
                      .format(widget.date!)
                      .toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      " ${widget.downloads}",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 8),
                  child: ButtonSquare(
                    text: "Downloads",
                    color1: Colors.green,
                    color2: Colors.lightGreen,
                    press: () async {
                      try {
                        var imageId =
                            await ImageDownloader.downloadImage(widget.img!);
                        if (imageId == null) {
                          return;
                        }
                        Fluttertoast.showToast(msg: "Image Saved to gallery");
                        total = widget.downloads! + 1;

                        FirebaseFirestore.instance
                            .collection('wallpaper')
                            .doc(widget.docId)
                            .update({
                          'downloads': total,
                        }).then((value) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => HomeScreen()));
                        });
                      } on PlatformException catch (error) {
                        print(error);
                      }
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 14, right: 14),
                //   child: ButtonSquare(
                //     text: "Download",
                //     color1: Colors.green,
                //     color2: Colors.lightGreen,
                //     press: () async {
                //       try {
                //         var imageId =
                //             await ImageDownloader.downloadImage(widget.img!);
                //         if (imageId == null) {
                //           return;
                //         }
                //         Fluttertoast.showToast(msg: "Image Saved to Gallery");
                //         total = widget.downloads! + 1;

                //         FirebaseFirestore.instance
                //             .collection('wallpaper')
                //             .doc(widget.docId)
                //             .update({
                //           'downloads': total,
                //         }).then((value) {
                //           Navigator.pushReplacement(context,
                //               MaterialPageRoute(builder: (_) => HomeScreen()));
                //         });
                //       } on PlatformException catch (error) {
                //         print(error);
                //       }
                //     },
                //   ),
                // ),
                FirebaseAuth.instance.currentUser!.uid == widget.userId
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: ButtonSquare(
                          text: 'Delete',
                          color1: Colors.green,
                          color2: Colors.lightGreen,
                          press: () async {
                            FirebaseFirestore.instance
                                .collection('wallpaper')
                                .doc(widget.docId)
                                .delete()
                                .then((value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomeScreen()));
                            });
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: ButtonSquare(
                    text: "Go Back",
                    color1: Colors.green,
                    color2: Colors.lightGreen,
                    press: () async {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
