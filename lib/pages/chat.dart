import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renawiweb/widgets/bubbleMessage.dart';
import 'package:renawiweb/widgets/newMessage.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final chatId;
  final String senderName;
  const Chat({Key? key, this.chatId, required this.senderName})
      : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  updatehUnreadMessages() async {
    await firebaseFirestoreInstance
        .collection('centers')
        .doc('renawi')
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .where('fromcenter', isEqualTo: false)
        .where('isRead', isEqualTo: false)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await firebaseFirestoreInstance
            .collection('centers')
            .doc('renawi')
            .collection('chats')
            .doc(widget.chatId)
            .collection('messages')
            .doc(element.id)
            .update({'isRead': true});
      });
    });
  }

  var firebaseFirestoreInstance = FirebaseFirestore.instance;
  List chatList = [];
  var chats;
  bool getComplete = false;

  getData() async {
    chats = firebaseFirestoreInstance
        .collection('centers')
        .doc('renawi')
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true);
    print(chats.toString());
    await chats.snapshots().listen((event) {
      chatList.clear();
      event.docs.forEach((element) {
        setState(() {
          chatList.add(element.data());
        });
      });
    });
    setState(() {
      getComplete = true;
    });
    updatehUnreadMessages();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: !getComplete
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    CircleAvatar(
                        // backgroundImage: AssetImage('assets/icons/logo.png'),
                        ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.senderName,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              body: Column(
                children: [
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: chatList.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(
                                isImage: chatList[index]['isImage'],
                                message: chatList[index]['content'],
                                isMe: !chatList[index]['fromcenter']);
                          }),
                    ),
                  ),
                  NewMessage(
                    doc: widget.chatId,
                  )
                ],
              ),
            ),
    );
  }
}
