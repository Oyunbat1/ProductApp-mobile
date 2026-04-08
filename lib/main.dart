import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productapp/screen/home.dart';
import 'package:productapp/screen/login.dart';
import 'package:productapp/service/auth_service.dart';

import 'firebase_options.dart';

Future<void> main() async {
  /*firebase-connection*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /*firebase-connection*/



  runApp(MyApp());
}


class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 400),
      home: StreamBuilder<User?>(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.hasData ? HomeScreen() : LoginScreen();
        },
      )
    );
  }
}


