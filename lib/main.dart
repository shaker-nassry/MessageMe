import 'package:flutter/material.dart';
import 'package:messageme/screens/chat_screen.dart';
import 'package:messageme/screens/registration_screen.dart';
import 'package:messageme/screens/sign_in_screen.dart';
import 'package:messageme/screens/welcomescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  /*await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  final _auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      //home: WelcomeScreen() ,
      initialRoute: _auth.currentUser != null ? ChatScreen.routename : WelcomeScreen.routename,
      routes: {
        "Registration Screen" :(context) => Registration_screen() ,
        WelcomeScreen.routename : (context) => WelcomeScreen() ,
        SignInScreen.routename : (context) => SignInScreen() ,
        ChatScreen.routename : (context) => ChatScreen() ,
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
