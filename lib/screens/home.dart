import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:wake_up/screens/takePictureScreen.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;

  const HomeScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

// A widget that displays the picture taken by the user.
class HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    // Initialize Authentication check
    initializeAuth();
  }

  void initializeAuth(){
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TakePictureScreen(
              // Pass the appropriate camera to the TakePictureScreen widget.
              camera: widget.camera,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GO TOUT DÉFONCER')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              obscureText: false,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Email",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Mot de passe",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios),
        onPressed:  () async {
          try {
            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.value.text,
            password: _passwordController.value.text
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              print('Wrong password provided for that user.');
            }
          }
        },
      ),
    );
  }
}