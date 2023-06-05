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
  final File? profileImage;

  const HomePage({Key? key, this.profileImage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  List<Select> selected = [];
  late String currentDate;

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    if (widget.profileImage != null) {
      setState(() {
        _profileImage = widget.profileImage;
      });
    } else {
      var url = await FirebaseStorage.instance
          .ref('profile_image.jpg')
          .getDownloadURL();
      setState(() {
        _profileImage = File(url);
      });
    }
  }

  void _selectProfileImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });

      await FirebaseStorage.instance
          .ref('profile_image.jpg')
          .putFile(_profileImage!);
    }
  }

  void _deleteProfileImage() async {
    await FirebaseStorage.instance.ref('profile_image.jpg').delete();

    setState(() {
      _profileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    currentDate = DateFormat('EEEE dd').format(DateTime.now());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "Today's Tasks",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(
                  top: 8.0, right: 8.0), // Add margin here
              child: Padding(
                padding: EdgeInsets.zero,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: const [
                      Colors.indigoAccent,
                      Colors.purpleAccent,
                    ]),
                  ),
                  child: ClipOval(
                    child: _profileImage != null
                        ? Image.file(
                            _profileImage!,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.person,
                            size: 30,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                  ),
                ),
              ),
            ),
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
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
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
                    builder: (builder) => const AddTodoPage(),
                  ),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => ProfilePage(
                      key:
                          UniqueKey(), // Add a unique key to force the widget to rebuild
                      profileImage: _profileImage,
                      onSelectProfileImage: _selectProfileImage,
                      onDeleteProfileImage: _deleteProfileImage,
                    ),
                  ),
                );
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
              selected.add(
                Select(
                  id: snapshot.data!.docs[index].id,
                  checkValue: false,
                ),
              );
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
