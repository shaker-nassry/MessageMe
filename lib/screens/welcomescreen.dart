import 'package:flutter/material.dart';
import 'package:messageme/screens/registration_screen.dart';
import 'package:messageme/screens/sign_in_screen.dart';
import '../widgets/buttons.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routename = "Welcome Screen";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar:  AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text('MessageMe' , style: TextStyle(fontWeight: FontWeight.bold),) ,
      ),*/
      //backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 180,
            child: Image.asset("assets/images/logo.png"),
          ),
          Text(
            'MessageMe',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.blue[900],
            ),
            textAlign: TextAlign.center,
          ),
          //Buttons
          myButton(
              color: Colors.orange!,
              title: 'Sign in',
              onPress: () {
                Navigator.pushReplacementNamed(context, SignInScreen.routename);
              }),
          myButton(
              color: Colors.blue[900]!,
              title: 'Sign up',
              onPress: () {
                Navigator.pushReplacementNamed(context, Registration_screen.routename);
              })
        ],
      ),
    );
  }
}
