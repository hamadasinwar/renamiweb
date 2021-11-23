import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List Posts = [];
  getPosts() {
    CollectionReference us = FirebaseFirestore.instance.collection('posts');
    us.snapshots().listen((event) {
      Posts.clear();
      event.docs.forEach((element) {
        setState(() {
          Posts.add({'PostData': element.data(), 'PostId': element.id});
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPosts();
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
        itemCount: Posts.length,
        itemBuilder: (context, index) {
          return Cart(
            color: Colors.purple,
            postData: Posts[index]['PostData'],
            postId: Posts[index]['PostId'],
          );
        },
      ),
    );
  }
}

class Cart extends StatefulWidget {
  final Color color;
  final Map<String, dynamic> postData;
  final postId;

  const Cart(
      {required this.color, required this.postData, required this.postId});
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
                    SizedBox(
                      width: 18,
                    ),
                    Container(
                      child: Text(
                        widget.postData['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: hovered ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                row(widget.postData['describe'], Icons.content_paste),
                row(
                    DateFormat('yyyy-MM-dd ')
                        .format(widget.postData['createdAt'].toDate()),
                    Icons.calendar_today),
                row(widget.postData['videoLink'], Icons.link),
              ],
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
    Widget detailsButton = TextButton(
      child: Text("تعديل المنشور"),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new MyHomePage(
              index: 11,
              courseId: widget.postId,
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
        widget.postData['title'],
        textAlign: TextAlign.end,
      ),
      actions: [
        cancelButton,
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
