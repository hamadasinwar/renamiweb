import 'package:renawiweb/pages/addCourse.dart';
import 'package:renawiweb/pages/addpost.dart';
import 'package:renawiweb/pages/chats.dart';
import 'package:renawiweb/pages/courseDetails.dart';
import 'package:renawiweb/pages/courseUsers.dart';
import 'package:renawiweb/pages/courses.dart';
import 'package:renawiweb/pages/genderPercent.dart';
import 'package:renawiweb/pages/posts.dart';
import 'package:renawiweb/pages/updateCourse.dart';
import 'package:renawiweb/pages/updatePost.dart';
import 'package:renawiweb/pages/users.dart';
import 'package:renawiweb/pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daburiyya Control Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Login()
      //   MyHomePage(index: 0, courseId: '',)
      ,
      routes: {
        MyHomePage.route: (context) => MyHomePage(
              index: 0,
              courseId: '',
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static String route = 'My-Home-Page';
  final int index;

  String? courseId;

  MyHomePage({required this.index, this.courseId});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showDetails = false;

  late int index;

  late List pages;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    pages = [
      WelcomeScreen(),
      Users(),
      AddCourse(),
      Courses(),
      GenderPercent(),
      CourseDetails(
        courseId: widget.courseId!,
      ),
      CourseUsers(
        courseId: widget.courseId,
      ),
      UpdateCourse(
        courseId: widget.courseId,
      ),
      MyChats(),
      AddPost(),
      Posts(),
      UpdatePost(
        postId: widget.courseId,
      )
    ];
  }

  var sidebarStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width * 0.12,
              color: Colors.deepPurple,
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text('لوحة تحكم', style: sidebarStyle),
                    // collapsedIconColor: Colors.white,
                    // iconColor: Colors.white,
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) => new MyHomePage(
                                index: 0,
                                courseId: '',
                              ),
                            ),
                          );
                        },
                        trailing: Icon(Icons.home, color: Colors.white),
                        title: Text('الرئيسية', style: sidebarStyle),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        trailing: Icon(Icons.supervised_user_circle,
                            color: Colors.white),
                        title: Text('المستخدمون', style: sidebarStyle),
                      ),
                    ],
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        index = 10;
                      });
                    },
                    //  leading: Icon(Icons.keyboard_control),
                    title: Text(' المنشورات', style: sidebarStyle),
                    trailing: Icon(Icons.list_rounded, color: Colors.white),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        index = 9;
                      });
                    },
                    //  leading: Icon(Icons.keyboard_control),
                    title: Text('إضافة منشور', style: sidebarStyle),
                    trailing: Icon(Icons.add, color: Colors.white),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        index = 3;
                      });
                    },
                    //  leading: Icon(Icons.keyboard_control),
                    title: Text('الدورات', style: sidebarStyle),
                    trailing: Icon(Icons.list_rounded, color: Colors.white),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    //  leading: Icon(Icons.keyboard_control),
                    title: Text('إضافة دورة', style: sidebarStyle),
                    trailing:
                        Icon(Icons.add_circle_outline, color: Colors.white),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        index = 4;
                      });
                    },
                    //  leading: Icon(Icons.keyboard_control),
                    title: Text('إحصائيات', style: sidebarStyle),
                    trailing: Icon(Icons.show_chart, color: Colors.white),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        index = 8;
                      });
                    },
                    //  leading: Icon(Icons.keyboard_control),
                    title: Text('المراسلات', style: sidebarStyle),
                    trailing: Icon(Icons.chat, color: Colors.white),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Login(),
                        ),
                      );
                    },
                    //  leading: Icon(Icons.keyboard_control),
                    title: Text('تسجيل الخروج', style: sidebarStyle),
                    trailing: Icon(Icons.logout, color: Colors.white),
                  )
                ],
              ),
            ),
            pages[index],
          ],
        ),
      ),
    );
  }
}
