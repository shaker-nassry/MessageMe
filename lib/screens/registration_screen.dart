import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messageme/screens/chat_screen.dart';
import 'package:messageme/screens/welcomescreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/buttons.dart';

class Registration_screen extends StatefulWidget {
  static const String routename = "Registration Screen";

  const Registration_screen({super.key});

  @override
  State<Registration_screen> createState() => _Registration_screenState();
}

class _Registration_screenState extends State<Registration_screen> {
  late String username = '' ;
  late String email = '' ;
  late String password = '' ;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance ;
  bool showIndicator = false ;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( icon: Icon(Icons.home ,color: Colors.white),   onPressed: (){Navigator.pushReplacementNamed(context, WelcomeScreen.routename );},),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text("Registration" , style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),

      ),
      body: ModalProgressHUD(
        inAsyncCall: showIndicator,
        child: Stack(
          children:[

            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 180,),
                  Form
                    (
                    key: _formKey,
                    child : Container(
                      margin: EdgeInsets.fromLTRB(35, 5, 35, 0),
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'User Name',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent ,
                                    width: 3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onChanged: (text){
                              username = text ;
                            },
                            validator: (text){
                              if (text == null || text.trim().isEmpty){
                                return 'please enter user name' ;
                              }
                              return null;
                            },
                          ) ,
                          SizedBox(height: 10,),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'E-Mail',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent ,
                                    width: 3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onChanged: (text){
                              email = text ;
                            },
                            validator: (text){
                              final bool emailValid =
                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(text!);
                              if (emailValid == false ){
                                return 'Please Enter Valid E-mail' ;
                              }
                              return null;
                            },
                          ) ,
                          SizedBox(height: 10,),
                          TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                labelText: 'password' ,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent ,
                                    width: 3),
                                borderRadius: BorderRadius.circular(15),

                              ),
                            ),
                            onChanged: (text){
                              password = text ;
                            },

                            validator: (text){
                              if (text == null || text.trim().isEmpty){
                                return 'please enter your password' ;
                              }
                              if(text.length < 6 ){
                                return 'password must be at least 6 chrachters' ;
                              }
                              return null;
                            },
                          ) ,
                          Column (  children: [
                            myButton(color: Colors.orange, title: "Creat Account",
                                onPress: () async {
                              setState(() {
                                showIndicator = true ;
                              });
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    try {
                                      final NewUser = await _auth
                                          .createUserWithEmailAndPassword(
                                          email: email,
                                          password: password);
                                      Navigator.pushReplacementNamed(
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
                                        content: Text('Check Data'),
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
                          ]),
                        ],
                      ),
                    ),),
                ],
              ),
            ),
            Container(

              color: Colors.white,
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10,) ,
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
                  Container(
                    color: Colors.orange,
                    height: 1,
                  ),
                ],
              ),
            ),
  ]),
      ),
    );
  }
}
