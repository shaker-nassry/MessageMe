import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messageme/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance ;
late User SignedInUser;

class ChatScreen extends StatefulWidget {
  static const String routename = "ChatScreen Screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String ? messageText ;

  @override
  void initState() {
    getCurrentUser();
    print(SignedInUser.email);
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        SignedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  /*void getMessages ()async{
    final messages = await _firestore.collection('Messages').get();
    for (var message in messages.docs ){
      print(message.data());
    };
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Chat'),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacementNamed(context, SignInScreen.routename);
                print('Signed out');
              },
              icon: Icon(Icons.logout))
        ],
        leading:
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_outlined)),
      ),
      body: SafeArea(
          //  Message text field
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          streamBuilder(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.orange, width: 2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions_outlined)),
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                          hintText: 'Message...',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      onChanged: (text) {
                        messageText = text ;
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {

                      },
                      icon: Icon(
                        Icons.attach_file_rounded,
                        color: Colors.black,
                      )),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (messageText!.trim().isNotEmpty) {
                          _firestore.collection('Messages').add({
                            'text': messageText,
                            'sender': SignedInUser.email,
                            'time': FieldValue.serverTimestamp(),
                          });
                          messageController.clear();
                          messageText = null ;
                        }},
                      icon: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                  // MICROPHONE
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mic, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

}
class streamBuilder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Messages').orderBy('time').snapshots(),
        builder: (context , snapshot){
          List<Widget> messageWidgets = [];
          if(!snapshot.hasData) {
            return Center(
              heightFactor: 3,
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }
          final messages = snapshot.data!.docs.reversed ;
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = SignedInUser.email;
            /////////////////////////////////////////////////
            final messageWidget = messageDesign(
              text: messageText ,
              sender: messageSender,
              isMe: currentUser== messageSender ,
            );
            messageWidgets.add(messageWidget) ;
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children:messageWidgets ,
            ),
          );

        });
  }
}



class messageDesign extends StatelessWidget {
  messageDesign ({this.text , this.sender, required this.isMe });

  final String? sender ;
  final String? text ;
  final bool isMe ;


@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),

      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text('$sender' , style: TextStyle(color: Colors.grey , fontSize: 10),) ,

          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isMe ? Colors.orange : Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10) ,
                bottomRight: Radius.circular(10) ,
                topLeft: isMe ? Radius.circular(10) : Radius.circular(0) ,
                topRight: isMe ? Radius.circular(0) : Radius.circular(10) ,

              ),
            ),
            child: Text('$text' , style: TextStyle(
              color: Colors.white ,
              fontSize: 20
            ),),
          )

        ],

      ),
    );
  }
}
