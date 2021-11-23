import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseUsers extends StatefulWidget {
  final courseId;

  const CourseUsers({required this.courseId});

  @override
  _CourseUsersState createState() => _CourseUsersState();
}

class _CourseUsersState extends State<CourseUsers> {
  var data;

  List users = [];
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
        for (var id in data['users']) {
          print(id);
          FirebaseFirestore.instance
              .collection('centers')
              .doc('renawi')
              .collection('users')
              .doc(id)
              .get()
              .then((value) {
            setState(() {
              users.add(value.data());
            });
          });
        }
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getComplete
        ? Container(
            width: MediaQuery.of(context).size.width * .88,
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                childAspectRatio: 2.5 / 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Cart(
                    color: Colors.deepPurple,
                    userData: users[index],
                    courseTitle: data['title'],
                    allUsers: users);
              },
            ),
          )
        : Container();
  }
}

class Cart extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> userData;
  final String courseTitle;
  final List allUsers;

  const Cart({
    required this.color,
    required this.userData,
    required this.courseTitle,
    required this.allUsers,
  });

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showAlertDialog(context, widget.courseTitle);
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
          width: hovered ? 200 : 195,
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
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.person,
                        color: !hovered ? Colors.white : Colors.black,
                        size: 16.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: hovered ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    Container(
                      child: Text(
                        widget.userData['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: hovered ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                row(
                  widget.userData['email'],
                  Icons.email,
                ),
                row(
                  DateFormat('yyyy-MM-dd ')
                      .format(widget.userData['dateOFBirth'].toDate()),
                  Icons.calendar_today,
                ),
                row(
                  widget.userData['phone'],
                  Icons.phone,
                ),
                row(
                  widget.userData['gender'],
                  widget.userData['gender'] == 'أنثى'
                      ? Icons.face
                      : Icons.person,
                ),
                row(
                  widget.userData['socialStatus'],
                  Icons.menu,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchMailClient() async {
    try {
      await launch("mailto:" + widget.userData['email']);
    } catch (e) {}
  }

  void _launchAllMailClient() async {
    var emails = "";
    for (var user in widget.allUsers) {
      emails += user['email'] + ";";
    }
    try {
      await launch("mailto:" + emails);
    } catch (e) {}
  }

  void _launchWhatsappClient() async {
    int phone = int.parse(widget.userData['phone'].toString());
    var whatsappUrl = "whatsapp://send?phone=00972$phone";
    print(whatsappUrl);
    try {
      await launch(whatsappUrl);
    } catch (e) {}
  }

  showAlertDialog(BuildContext context, String title) {
    Widget usersButton = TextButton(
      child: Text("${widget.userData['name']}إرسال إيميل ل"),
      onPressed: () {
        _launchMailClient();
        Navigator.of(context).pop();
      },
    );
    Widget allUsersButton = TextButton(
      child: Text("إرسال إيميل لجميع المشتركين"),
      onPressed: () {
        _launchAllMailClient();
        Navigator.of(context).pop();
      },
    );
    Widget detailsButton = TextButton(
      child: Text("مراسلة واتساب"),
      onPressed: () {
        _launchWhatsappClient();
        Navigator.of(context).pop();
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
        title,
        textAlign: TextAlign.end,
      ),
      actions: [
        cancelButton,
        usersButton,
        allUsersButton,
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
              child: Text(
                data,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.0,
                  color: hovered ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
