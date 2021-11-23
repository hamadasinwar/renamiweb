import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renawiweb/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatCover extends StatefulWidget {
  final user;
  final chatId;
  final index;
  final Timestamp lastEdit;
  const ChatCover({
    this.chatId,
    this.index,
    required this.lastEdit,
    this.user,
  });

  @override
  State<ChatCover> createState() => _ChatCoverState();
}

class _ChatCoverState extends State<ChatCover> {
  late int unreadMessages;
  bool dataComplete = false;
  fetchUnreadMessages() async {
    var unreadChats = FirebaseFirestore.instance
        .collection('centers')
        .doc('renawi')
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .where('fromcenter', isEqualTo: false)
        .where('isRead', isEqualTo: false);
    unreadChats.snapshots().listen((event) {
      setState(() {
        unreadMessages = event.docs.length;
        dataComplete = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUnreadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: !dataComplete
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Chat(
                              chatId: widget.chatId,
                              senderName: widget.user["name"],
                            )));
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.height * .08,
                    height: MediaQuery.of(context).size.height * .08,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Text('${widget.index + 1}'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text(widget.user["name"]),
                      Text(
                          DateFormat('yyyy-MM-dd – kk:mm')
                              .format(widget.lastEdit.toDate()),
                          style: TextStyle(color: Colors.grey))
                    ],
                  ),
                  Spacer(),
                  unreadMessages == 0 || unreadMessages == null
                      ? SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.height * .05,
                          height: MediaQuery.of(context).size.height * .05,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.shade300),
                          alignment: Alignment.center,
                          child: Text(
                            '$unreadMessages',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                ],
              )),
    );
  }
}
