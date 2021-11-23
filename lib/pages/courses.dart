import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  List courses = [];
  getCourses() {
    CollectionReference us = FirebaseFirestore.instance
        .collection('centers')
        .doc('renawi')
        .collection('courses');
    us.snapshots().listen((event) {
      courses.clear();
      event.docs.forEach((element) {
        setState(() {
          courses.add({'courseData': element.data(), 'courseId': element.id});
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .88,
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(30),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 2.5 / 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Cart(
            color: Colors.purple,
            courseData: courses[index]['courseData'],
            courseId: courses[index]['courseId'],
          );
        },
      ),
    );
  }
}

class Cart extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> courseData;
  final courseId;

  const Cart(
      {required this.color, required this.courseData, required this.courseId});
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          showAlertDialog(context);
        },
        child: MouseRegion(
          onEnter: (val) {
            setState(() {
              hovered = true;
            });
          },
          onExit: (val) {
            setState(() {
              hovered = false;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 275),
            height: hovered ? 160 : 155,
            width: hovered ? 320 : 315,
            decoration: BoxDecoration(
                color: hovered ? widget.color : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 20, spreadRadius: 5)
                ]),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 18),
                        child: Text(
                          widget.courseData['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: hovered ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  row(widget.courseData['describe'], Icons.content_paste),
                  row(
                      DateFormat('yyyy-MM-dd ')
                          .format(widget.courseData['createdAt'].toDate()),
                      Icons.calendar_today),
                  row(widget.courseData['videoLink'], Icons.link),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget row(String data, IconData icon) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 18.0,
              ),
              Container(
                height: 13.0,
                width: 13.0,
                child: Icon(
                  icon,
                  size: 13.0,
                  color: hovered ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Container(
                //  margin: EdgeInsets.symmetric(vertical: 2),
                child: Expanded(
                    child: Text(
                  data,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.0,
                    color: hovered ? Colors.white : Colors.black,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget usersButton = TextButton(
      child: Text("عرض المسجلين"),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new MyHomePage(
              index: 6,
              courseId: widget.courseId,
            ),
          ),
        );
      },
    );
    Widget detailsButton = TextButton(
      child: Text("تفاصيل الدورة"),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new MyHomePage(
              index: 5,
              courseId: widget.courseId,
            ),
          ),
        );
      },
    );
    Widget cancelButton = TextButton(
      child: Text("إلغاء"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        widget.courseData['title'],
        textAlign: TextAlign.end,
      ),
      actions: [
        cancelButton,
        usersButton,
        detailsButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
