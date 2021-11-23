import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:renawiweb/widgets/roundedInput.dart';

import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailLoginburiyya = TextEditingController();
  TextEditingController passLoginburiyya = TextEditingController();
  GlobalKey<FormState> LoginformStateburiyya = new GlobalKey<FormState>();

  TextEditingController emailLoginrenawy = TextEditingController();
  TextEditingController passLoginrenawy = TextEditingController();
  GlobalKey<FormState> LoginformStaterenawy = new GlobalKey<FormState>();
  signindaburiyya(BuildContext context) async {
    var formdata = LoginformStateburiyya.currentState;
    if (formdata!.validate()) {
      formdata.save();
      if (emailLoginburiyya.text.trim() != 'rashed.fathy.o@gmail.com') {
        // Navigator.of(context).pop();
        AwesomeDialog(
            context: context, title: "خطأ", body: Text("الإيميل غير صحيح "))
          ..show();
      } else if (passLoginburiyya.text.trim() != '123456') {
        // Navigator.of(context).pop();
        AwesomeDialog(
            context: context, title: "خطأ", body: Text("كلمة المرور غير صحيحة"))
          ..show();
      } else {
        Navigator.of(context).pushReplacementNamed(MyHomePage.route);
      }
    } else {
      print('error');
    }
  }

  signindarenawy(BuildContext context) async {
    var formdata = LoginformStaterenawy.currentState;
    if (formdata!.validate()) {
      formdata.save();
      if (emailLoginrenawy.text.trim() != 'rashed.fathy.o@gmail.com') {
        // Navigator.of(context).pop();
        AwesomeDialog(
            context: context, title: "خطأ", body: Text("الإيميل غير صحيح "))
          ..show();
      } else if (passLoginrenawy.text.trim() != '123456') {
        // Navigator.of(context).pop();
        AwesomeDialog(
            context: context, title: "خطأ", body: Text("كلمة المرور غير صحيحة"))
          ..show();
      } else {
        Navigator.of(context).pushReplacementNamed(MyHomePage.route);
      }
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var Conwidth = MediaQuery.of(context).size.width / 2;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Row(
          children: [
            Container(
              width: Conwidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.red,
                  ],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: AssetImage(
                        'assets/icon.jpeg',
                        //  fit: BoxFit.contain,
                      )),
                    ),
                    height: 300,
                    width: 300,
                  ),
                  Form(
                      key: LoginformStateburiyya,
                      child: Column(
                        children: [
                          InputContainer(
                            child: TextFormField(
                              validator: (val) {
                                if (!val!.contains('@')) {
                                  return "يجب أن يحتوي الإيميل على علامة @";
                                }
                                if (val.length < 7) {
                                  return "لا يمكن أن يكون الإيميل بهذا الطول ";
                                }
                                return null;
                              },
                              controller: emailLoginburiyya,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                hintText: 'البريد الإلكتروني',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InputContainer(
                              child: RoundedPassword(
                            pass: passLoginburiyya,
                          )),
                        ],
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal:
                                    MediaQuery.of(context).size.width * .05)),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColorLight),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ))),
                    onPressed: () {
                      signindaburiyya(context);
                    },
                    child: Text('تسجيل الدخول'),
                  )
                ],
              ),
            ),
            Container(
              width: Conwidth,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.red,
                ],
              )),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      child: Image.asset('assets/dabicon.png'),
                      height: 300,
                      width: 300),
                  Form(
                      key: LoginformStaterenawy,
                      child: Column(
                        children: [
                          InputContainer(
                            child: TextFormField(
                              validator: (val) {
                                if (!val!.contains('@')) {
                                  return "يجب أن يحتوي الإيميل على علامة @";
                                }
                                if (val.length < 7) {
                                  return "لا يمكن أن يكون الإيميل بهذا الطول ";
                                }
                                return null;
                              },
                              controller: emailLoginrenawy,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                hintText: 'البريد الإلكتروني',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InputContainer(
                              child: RoundedPassword(
                            pass: passLoginrenawy,
                          )),
                        ],
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal:
                                    MediaQuery.of(context).size.width * .05)),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColorLight),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ))),
                    onPressed: () {
                      signindarenawy(context);
                    },
                    child: Text('تسجيل الدخول'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
