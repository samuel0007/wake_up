import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wake_up/screens/home.dart';


Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[1];
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: HomeScreen(camera: firstCamera),
    ),
  );
}


