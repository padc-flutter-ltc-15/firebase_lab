import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_installations/firebase_installations.dart';
import 'package:firebase_lab/pages/login_page.dart';
import 'package:firebase_lab/pages/news_feed_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/models/authentication_model_impl.dart';
import 'fcm/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FCMService().listenForMessages();

  var firebaseInstallationId =
      await FirebaseInstallations.id ?? 'Unknown installation id';
  debugPrint("Firebase Installation id =====> $firebaseInstallationId");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _authenticationModel = AuthenticationModelImpl();

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.ubuntu().fontFamily),
      home: (_authenticationModel.isLoggedIn())
          ? const NewsFeedPage()
          : const LoginPage(),
    );
  }
}
