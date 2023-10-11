import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveUserDataToFirestore(String email, String username) async {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Create a map of user data
    final userData = {
      'uid': user.uid,
      'email': email,
      'username': username,
    };

    // Add the data to the "users" collection with the user's UID as the document ID
    await firestore.collection('users').doc(user.uid).set(userData);
  }
}

Future<Map<String, dynamic>?> getUserData(String userUID) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final userDocument = await firestore.collection('users').doc(userUID).get();
    if (userDocument.exists) {
      // User data exists, you can access it as a Map
      return userDocument.data() as Map<String, dynamic>;
    } else {
      // User data doesn't exist in Firestore
      return null;
    }
  } catch (e) {
    // Handle any errors that occur during the retrieval
    print("Error retrieving user data: $e");
    return null;
  }
}
