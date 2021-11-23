import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width * 0.88,
      child: Center(
        child: Text(
          "أهلا بك في لوحة التحكم الخاصة بريناوي",
          style: TextStyle(color: Colors.deepPurple, fontSize: 25),
        ),
      ),
    );
  }
}
