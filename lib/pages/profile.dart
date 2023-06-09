import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/themes/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  final File? profileImage;
  final VoidCallback onSelectProfileImage;
  final VoidCallback onDeleteProfileImage;

  const ProfilePage({
    Key? key,
    this.profileImage,
    required this.onSelectProfileImage,
    required this.onDeleteProfileImage,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _profileImage = widget.profileImage;
  }

  @override
  void didUpdateWidget(ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileImage != widget.profileImage) {
      setState(() {
        _profileImage = widget.profileImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        foregroundColor: themeProvider.getTheme().colorScheme.secondary,
        backgroundColor:
            themeProvider.getTheme().colorScheme.secondaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: widget.onSelectProfileImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
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
                            size: 100,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.onDeleteProfileImage,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Text(
                  'Remove Profile Picture',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
