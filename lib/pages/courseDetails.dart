import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renawiweb/pages/updateCourse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class CourseDetails extends StatefulWidget {
  final String courseId;

  const CourseDetails({required this.courseId});
  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  var data;
  bool getComplete = false;
  getData() {
    FirebaseFirestore.instance
        .collection('centers')
        .doc('renawi')
        .collection('courses')
        .doc(widget.courseId)
        .get()
        .then((value) {
      setState(() {
        data = value.data();
      });
    }).then((_) {
      setState(() {
        getComplete = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getComplete
          ? Cart(
              color: Colors.amber.shade500,
              courseData: data,
              courseId: widget.courseId,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class Cart extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> courseData;
  final courseId;

  const Cart({required this.color, required this.courseData, this.courseId});
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          width: hovered ? 300 : 295,
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
                    SizedBox(
                      width: 18,
                    ),
                    Container(
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
    );
  }

  Widget row(String data, IconData icon) {
    return Column(
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
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget usersButton = TextButton(
      child: Text("تعديل الكورس"),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new MyHomePage(
              index: 7,
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
