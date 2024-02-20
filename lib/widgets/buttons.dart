import 'package:flutter/material.dart';

class myButton extends StatelessWidget {
  myButton({required this.color, required this.title, required this.onPress});
  final Color color;
  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 50), backgroundColor: color),
            onPressed: onPress,
            child: Text("$title",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                )),
          ),
        ]));
  }
}
