import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  // ignore: prefer_final_fields
  TextEditingController _titleController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _descriptionController = TextEditingController();
  String type = "";
  String category = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ]),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.arrow_left,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 28,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "New To-do",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    label("Task Title"),
                    const SizedBox(
                      height: 12,
                    ),
                    title(),
                    const SizedBox(
                      height: 30,
                    ),
                    label("Task Type"),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect("Important", 0xff2664fa),
                        const SizedBox(
                          width: 20,
                        ),
                        taskSelect("Planned", 0xff2bc8d9),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    label("Task Description"),
                    const SizedBox(
                      height: 12,
                    ),
                    description(),
                    const SizedBox(
                      height: 25,
                    ),
                    label("Category"),
                    const SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categorySelect("Food", 0xffff6d6e),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Workout", 0xfff29732),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Work", 0xff6557ff),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Design", 0xff234ebd),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Run", 0xff2bc8d9),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    button(),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("Todo").add({
          "title": _titleController.text,
          "task": type,
          "category": category,
          "description": _descriptionController.text
        });
        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color(0xff8a32f1),
              Color(0xffad32f9),
            ],
          ),
        ),
        child: Center(
          child: Text(
            "Add To-do",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Description",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 17,
          ),
          contentPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          type = label;
        });
      },
      child: Chip(
        backgroundColor: type == label
            ? Theme.of(context).colorScheme.secondary
            : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: type == label
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
      child: Chip(
        backgroundColor: category == label
            ? Theme.of(context).colorScheme.secondary
            : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: category == label
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextFormField(
          controller: _titleController,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 17,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 17,
            ),
            contentPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 16.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2),
    );
  }
}
