import 'dart:typed_data';
import 'package:renawiweb/services/firestore_services.dart';
import 'package:renawiweb/services/push_notification.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path/path.dart';
import 'package:mime_type/mime_type.dart';
import 'package:firebase/firebase.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renawiweb/widgets/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  TextEditingController title = TextEditingController();

  TextEditingController content = TextEditingController();

  TextEditingController videoUrl = TextEditingController();

  String imageUrl = '';
  Uint8List? imageByte;

  bool chooseImage = false;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> users = [];

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    var u = await FirestoreServices.getAllUsers();
    users.addAll(u);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width * .88,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .05,
              ),
              SizedBox(
                width: 620,
                child: Form(
                    key: formState,
                    child: Column(children: [
                      TextFormField(
                        validator: (val) {
                          if (val!.length > 30) {
                            return "لا يمكن أن يكون العنوان أطول من 30 حرف";
                          }
                          if (val.length < 2) {
                            return "لا يمكن أن يكون العنوان أقل من حرفين";
                          }
                          return null;
                        },
                        controller: title,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.deepPurple, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "عنوان المنشور",
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              color: Colors.deepPurple,
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (val) {
                          if (val!.length > 255) {
                            return "لا يمكن أن يكون الوصف أكبر من 255 حرف";
                          }
                          if (val.length < 10) {
                            return "لا يمكن أن يكون الوصف أقل من 10 أحرف";
                          }
                          return null;
                        },
                        controller: content,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepPurple, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "تفاصيل المنشور",
                          prefixIcon: const Icon(
                            Icons.note,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: videoUrl,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.deepPurple, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "رابط فيديو توضيحي",
                            prefixIcon: const Icon(
                              Icons.link,
                              color: Colors.deepPurple,
                            )),
                      ),
                      const SizedBox(height: 20),
                      !chooseImage
                          ? ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                  width: 200, height: 40),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Colors.deepPurple,
                                              width: 2)),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: imagePicker,
                                child: const Text(
                                  "إضافة صورة توضيحية",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: size.height * .3,
                                  padding: const EdgeInsets.all(4),
                                  child: Image.memory(
                                    imageByte ?? Uint8List.fromList([]),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                imageUrl == ''
                                    ? CircularProgressIndicator(
                                        backgroundColor: Colors.white)
                                    : SizedBox()
                              ],
                            ),
                      const SizedBox(height: 20),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 300, height: 45),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.deepPurple)),
                          onPressed: () async {
                            await addPost(context);
                          },
                          child: const Text(
                            " إضافة المنشور",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    ])),
              )
            ],
          ),
        ),
      ),
    );
  }

  addPost(context) async {
    List<String> tokens = await FirestoreServices.getAllTokens();
    if (imageUrl.isEmpty && videoUrl.text.isEmpty) {
      return AwesomeDialog(
          width: MediaQuery.of(context).size.width * .3,
          context: context,
          title: "هام",
          body: const Text("يجب إضافة صورةأو رابط لفيديو توضيحي   "),
          dialogType: DialogType.ERROR)
        .show();
    }
    var formData = formState.currentState;
    if (formData!.validate()) {
      showLoading(context);
      formData.save();
      await FirebaseFirestore.instance.collection('posts').add({
        "title": title.text,
        "describe": content.text,
        "image": imageUrl,
        'videoLink': videoUrl.text,
        'createdAt': Timestamp.now(),
      }).then((value) async {
        await PushNotification.sendNotification(
            tokens, title.text, "منشور جديد", imageUrl
        );
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(MyHomePage.route);
      }).catchError((e) {
        AwesomeDialog(
            context: context,
            title: "خطأ",
            body: Text(e.toString()),
            dialogType: DialogType.ERROR)
          .show();
      });
    }
  }

  imagePicker() {
    return ImagePickerWeb.getImageInfo.then((MediaInfo mediaInfo) {
      setState(() {
        chooseImage = true;
        imageByte = mediaInfo.data;
      });
      uploadFile(mediaInfo, 'images', mediaInfo.fileName!);
    });
  }

  uploadFile(MediaInfo mediaInfo, String ref, String fileName) {
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
                    setState(() {
                      imageUrl = imageUri.toString();
                    });
                  })
                })
          });
    } catch (e) {
      print('File Upload Error: $e');
    }
  }
}
