import 'package:flutter/material.dart';

class RoundedPassword extends StatelessWidget {
  final TextEditingController pass;
  const RoundedPassword({Key? key, required this.pass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) {
        if (val!.length > 30) {
          return "لا يمكن أن تكون كلمة المرور أكبر من 30 حرف";
        }
        if (val.length < 6) {
          return "لا يمكن أن تكون كلمة المرور أقل من 6 أحرف";
        }
        return null;
      },
      controller: pass,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(
          Icons.remove_red_eye,
          color: Colors.white,
        ),
        hintText: 'كلمة المرور',
        border: InputBorder.none,
      ),
    );
  }
}

class InputContainer extends StatelessWidget {
  const InputContainer({Key? key, required this.child}) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 60, right: 60),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * .8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).primaryColor),
      child: child,
    );
  }
}
