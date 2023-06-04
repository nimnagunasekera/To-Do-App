// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo/custom/todo_card.dart';
import 'package:todo/pages/add_todo.dart';
import 'package:todo/pages/profile.dart';
import 'package:todo/pages/view_data.dart';
import 'package:todo/service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  List<Select> selected = [];
  late String currentDate;
  late String? imageUrl;
  late File? _image;

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });

      Reference ref = FirebaseStorage.instance.ref().child("profile.png");

      await ref.putFile(_image!);
      ref.getDownloadURL().then((value) {
        // ignore: avoid_print
        print(value);
        setState(() {
          imageUrl = value;
        });
      });
    }
  }

  void removeImage() {
    setState(() {
      _image = null;
      imageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    currentDate = DateFormat('EEEE dd').format(DateTime.now());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "Today's Tasks",
            style: TextStyle(
              letterSpacing: 1,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: removeImage,
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          InkWell(
            onTap: () {
              pickUploadImage();
            },
            child: Center(
              child: imageUrl == null
                  ? CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(imageUrl!),
                    ),
            ),
          ),
          SizedBox(
            width: 25,
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentDate,
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      var instance =
                          FirebaseFirestore.instance.collection("Todo");
                      for (int i = 0; i < selected.length; i++) {
                        if (selected[i].checkValue) {
                          instance.doc(selected[i].id).delete();
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 196, 16, 3),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      //Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Theme.of(context).colorScheme.secondary,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AddTodoPage()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Colors.indigoAccent,
                    Colors.purpleAccent,
                  ]),
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => const Profile()));
              },
              child: Icon(
                Icons.settings,
                size: 32,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            label: "",
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              IconData iconData;
              Color iconColor;
              Map<String, dynamic> document =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              switch (document["category"]) {
                case "Food":
                  iconData = Icons.local_grocery_store;
                  iconColor = Color(0xffff6d6e);
                  break;
                case "Work":
                  iconData = Icons.work;
                  iconColor = Color(0xff6557ff);
                  break;
                case "Workout":
                  iconData = Icons.fitness_center;
                  iconColor = Color(0xfff29732);
                  break;
                case "Design":
                  iconData = Icons.design_services;
                  iconColor = Color(0xff234ebd);
                  break;
                case "Run":
                  iconData = Icons.run_circle;
                  iconColor = Color(0xff2bc8d9);
                  break;
                default:
                  iconData = Icons.task_alt_outlined;
                  iconColor = Colors.blue;
              }
              selected.add(Select(
                id: snapshot.data!.docs[index].id,
                checkValue: false,
              ));
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => ViewData(
                        document: document,
                        id: snapshot.data!.docs[index].id,
                      ),
                    ),
                  );
                },
                child: TodoCard(
                  title: document["title"] ?? "",
                  check: selected[index].checkValue,
                  iconBgColor: Theme.of(context).colorScheme.secondary,
                  iconColor: iconColor,
                  iconData: iconData,
                  time: "",
                  index: index,
                  onChange: onChange,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select {
  String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}
