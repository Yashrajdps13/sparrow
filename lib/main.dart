// import 'package:flutter/material.dart';
// import 'package:sparrow/core/constants/app_colors.dart';
// import 'package:sparrow/features/pages/ListPage.dart';
// import 'package:sparrow/features/pages/ask_us.dart';
// import 'package:sparrow/features/pages/homepage.dart';
// import 'package:sparrow/features/pages/splash_screen.dart';
// import 'package:sparrow/pickimg.dart';
// import 'package:sparrow/route/app_pages.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       localizationsDelegates: [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: [
//         Locale('en'), // English
//         Locale('hi'), // Hindi
//       ],
//       home: ImageScreen(),
//     );
//   }
// }

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload to Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload to Firebase'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _signInAnonymously();
            _uploadImage(context);
          },
          child: Text('Pick and Upload Image'),
        ),
      ),
    );
  }

  Future<void> _uploadImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = path.basename(file.path);

      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images')
            .child(fileName);

        await ref.putFile(file);

        String imageUrl = await ref.getDownloadURL();

        // Now you can use 'imageUrl' to display the image or save it to a database
        print('Uploaded image URL: $imageUrl');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully!')),
        );
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image!')),
        );
      }
    } else {
      // User canceled the picker
      print('User canceled image picker.');
    }
  }
}
