// import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:path/path.dart' as path;

// class ImageScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;


//   Future<void> _signInAnonymously() async {
//     try {
//       await _auth.signInAnonymously();
//     } catch (e) {
//       print('Error signing in anonymously: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload to Firebase'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await _signInAnonymously();
//             _uploadImage(context);
//           },
//           child: Text('Pick and Upload Image'),
//         ),
//       ),
//     );
//   }

//   Future<void> _uploadImage(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowCompression: true,
//     );

//     if (result != null) {
//       File file = File(result.files.single.path!);
//       String fileName = path.basename(file.path);

//       try {
//         firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//             .ref()
//             .child('images')
//             .child(fileName);
        
//         await ref.putFile(file);
        
//         String imageUrl = await ref.getDownloadURL();
        
//         // Now you can use 'imageUrl' to display the image or save it to a database
//         print('Uploaded image URL: $imageUrl');
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Image uploaded successfully!')),
//         );
//       } catch (e) {
//         print('Error uploading image to Firebase Storage: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to upload image!')),
//         );
//       }
//     } else {
//       // User canceled the picker
//       print('User canceled image picker.');
//     }
//   }
// }