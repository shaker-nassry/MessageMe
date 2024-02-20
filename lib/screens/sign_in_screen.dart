import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageme/screens/chat_screen.dart';
import 'package:messageme/screens/registration_screen.dart';
import 'package:messageme/screens/welcomescreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/buttons.dart';

class SignInScreen extends StatefulWidget {
  static const String routename = "Sign in Screen";

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showIndicator = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          "Sign in",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showIndicator ,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100,
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
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(35, 5, 35, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'E-Mail',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onChanged: (text) {
                                  email = text;
                                },
                                validator: (text) {
                                  final bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(text!);
                                  if (emailValid == false) {
                                    return 'Please Enter Valid E-mail';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'password',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onChanged: (text) {
                                  password = text;
                                },
                                validator: (text) {
                                  if (text == null || text.trim().isEmpty) {
                                    return 'please enter your password';
                                  }
                                  if (text.length < 6) {
                                    return 'password must be at least 6 chrachters';
                                  }
                                  return null;
                                },
                              ),
                              Column(children: [
                                myButton(
                                    color: Colors.orange,
                                    title: "Sign in",
                                    onPress: () async {
                                      setState(() {
                                        showIndicator = true ;
                                      });
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKey.currentState!.validate()) {
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.
                                        try {
                                          final user = await _auth
                                              .signInWithEmailAndPassword(
                                                  email: email,
                                                  password: password);
                                          Navigator.popAndPushNamed(
                                              context, ChatScreen.routename);
                                          setState(() {
                                            showIndicator = false ;
                                          });
                                        } catch (e) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text('Something wrong'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          showIndicator = false ;
                                                        });
                                                      },
                                                      child: Text('ok'),
                                                    )
                                                  ],
                                                );
                                              });
                                        }
                                      }
                                      if (!_formKey.currentState!.validate()) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Text('Check your e-mail or password'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        showIndicator = false ;
                                                      });
                                                    },
                                                    child: Text('ok'),
                                                  )
                                                ],
                                              );
                                            });
                                      }

                                    }),
                                myButton(
                                    color: Colors.blueAccent,
                                    title: 'Dont have an account',


                                    onPress: () {
                                      Navigator.pushNamed(context, Registration_screen.routename) ;
                                    })
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
