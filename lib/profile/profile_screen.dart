import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_medical/repository/data_repository.dart';
import 'package:pet_medical/repository/user_data.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DataRepository repository = DataRepository();

  late String username;
  late String email;
  bool isEditing = false;
  bool isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await getUserData(user.uid);
      setState(() {
        username = userData?['username'] ?? '';
        email = user.email ?? '';
        isLoading = false; // Mark loading as complete
      });
    }
  }

  void saveChanges() {
    // Update user data in Firestore with username and email
    // Use repository.updateUser or a similar function
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveChanges,
            ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Display loading indicator while loading
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.network("https://imgur.com/VLvVD2v.jpg"),
                    ),
                  ),
                  if (isEditing)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        initialValue: username,
                        onChanged: (value) {
                          // Update the username
                          username = value;
                        },
                      ),
                    ),
                  if (!isEditing)
                    Text(
                      'Username: $username',
                      style: const TextStyle(fontSize: 18),
                    ),
                  if (isEditing)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        initialValue: email,
                        onChanged: (value) {
                          // Update the email
                          email = value;
                        },
                      ),
                    ),
                  if (!isEditing)
                    Text(
                      'Email: $email',
                      style: const TextStyle(fontSize: 18),
                    ),
                  if (!isEditing)
                    Text(
                      '',
                      style: const TextStyle(fontSize: 18),
                    ),
                ],
              ),
      ),
    );
  }
}
