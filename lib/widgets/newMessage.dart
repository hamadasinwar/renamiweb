import 'dart:io';
import 'dart:typed_data';
import 'package:renawiweb/pages/chat.dart';
import 'package:firebase/firebase.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final doc;
  const NewMessage({this.doc});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  void sendMessage(context, bool isImage, content) async {
    FocusScope.of(context).unfocus();
    var chats = FirebaseFirestore.instance
        .collection('centers')
        .doc('renawi')
        .collection('chats');
    var changeTime = Timestamp.now();
    await chats.doc(widget.doc).collection('messages').add({
      'content': content,
      'createdAt': changeTime,
      'fromcenter': true,
      'isRead': false,
      'isImage': isImage
    }).then((_) async {
      await chats.doc(widget.doc).update({'lastupdate': changeTime});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'ارسال رسالة .....',
                  suffixIcon: IconButton(
                    onPressed: () {
                      imagePicker(context);
                    },
                    icon: Icon(Icons.image),
                  )),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            )),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: _enteredMessage.trim().isEmpty
                  ? null
                  : () {
                      sendMessage(context, false, _enteredMessage);
                    },
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }

  bool chooseImage = false;
  Uint8List? imageByte;

  imagePicker(BuildContext context) {
    return ImagePickerWeb.getImageInfo.then((MediaInfo mediaInfo) {
      setState(() {
        chooseImage = true;
        imageByte = mediaInfo.data;
      });
      uploadFile(mediaInfo, 'images', mediaInfo.fileName!, context);
    });
  }

  uploadFile(
      MediaInfo mediaInfo, String ref, String fileName, BuildContext context) {
    try {
      String? mimeType = mime(basename(mediaInfo.fileName!));
      var metaData = UploadMetadata(contentType: mimeType);
      StorageReference storageReference = storage().ref(ref).child(fileName);

      var uploadTask = storageReference.put(mediaInfo.data, metaData);
      var imageUri;
      uploadTask.future.then((snapshot) => {
            Future.delayed(Duration(seconds: 1)).then((value) => {
                  snapshot.ref.getDownloadURL().then((dynamic uri) {
                    imageUri = uri;
                    print('Download URL: ${imageUri.toString()}');
                    sendMessage(context, true, imageUri.toString());
                  })
                })
          });
    } catch (e) {
      print('File Upload Error: $e');
    }
  }
}
