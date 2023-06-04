import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      // ignore: sized_box_for_whitespace
      body: SafeArea(
        // ignore: sized_box_for_whitespace
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 68,
                backgroundImage: getImage(),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button(),
                  IconButton(
                      onPressed: () async {
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          image = image;
                        });
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Colors.teal,
                        size: 30,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //This method is used to get the image from the gallery
  ImageProvider getImage() {
    if (image != null) {
      return FileImage(File(image!.path));
    } else {
      return const AssetImage("assets/avatar.png");
    }
  }

  Widget button() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 1, 138, 124),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            "Upload",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
