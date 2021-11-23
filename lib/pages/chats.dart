import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renawiweb/widgets/chatCover.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyChats extends StatefulWidget {
  static String route = 'MyChats_route';
  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  bool dataComplete = false;
  CollectionReference chats = FirebaseFirestore.instance
      .collection('centers')
      .doc('renawi')
      .collection('chats');
  List chatList = [];
  List chatsIds = [];
  List sendTo = [];
  late Query<Object?> myChats;
  getData() async {
    myChats = chats.orderBy('lastupdate', descending: true);
    await myChats.snapshots().listen((event) async {
      chatList.clear();
      chatsIds.clear();
      event.docs.forEach((element) {
        setState(() {
          chatsIds.add(element.id);
          chatList.add(element.data());
        });
      });
      sendTo.clear();
      for (int i = 0; i < chatList.length; i++) {
        await FirebaseFirestore.instance
            .collection('centers')
            .doc('renawi')
            .collection('users')
            .doc(chatList[i]['from'])
            .get()
            .then((value) {
          setState(() {
            sendTo.add(value);
          });
        });
      }
      setState(() {
        dataComplete = true;
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
    return !dataComplete
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              child: sendTo.isEmpty
                  ? Center(child: Text('لا يوجد مراسلات حتى الأن'))
                  : Expanded(
                      child: ListView.builder(
                          itemCount: chatList.length,
                          itemBuilder: (context, index) {
                            return ChatCover(
                                chatId: chatsIds[index],
                                index: index,
                                user: sendTo[index],
                                lastEdit: chatList[index]['lastupdate']);
                          }),
                    ),
            ),
          );
  }
}
