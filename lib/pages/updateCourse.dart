import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
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

enum Gender { Male, Female }
enum Age { lessThan20, moreThan40, between20and40 }

class UpdateCourse extends StatefulWidget {
  final courseId;

  const UpdateCourse({Key? key, this.courseId}) : super(key: key);
  @override
  _UpdateCourseState createState() => _UpdateCourseState();
}

class _UpdateCourseState extends State<UpdateCourse> {
  var data;
  bool getComplete = false;
  bool chooseImage = false;
  String imageUrl = '';
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
      title = TextEditingController(text: data['title']);
      content = TextEditingController(text: data['describe']);
      videoUrl = TextEditingController(text: data['videoLink']);
      _gender = data['gender'] == 'ذكر' ? Gender.Male : Gender.Female;
      _dropDownMenuItems = getDropDownMenuItems(ListSocialStatus);
      socialStatus = data['social'];
      if (data['image'] != '') {
        setState(() {
          chooseImage = true;
          imageUrl = data['image'];
        });
      }
    }).then((_) {
      setState(() {
        getComplete = true;
      });
    });
  }

  late TextEditingController title;

  late TextEditingController content;

  late TextEditingController videoUrl;
  late String socialStatus;
  List<String> ListSocialStatus = [
    '',
    'عازب/ة',
    'متزوج/ة',
    'مطلق/ة',
    'أرمل/ة',
  ];
  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<DropdownMenuItem<String>> getDropDownMenuItems(List<String> choices) {
    List<DropdownMenuItem<String>> items = [];
    for (String item in choices) {
      items.add(new DropdownMenuItem(value: item, child: new Text(item)));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    getData();
    setData();
  }

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  Uint8List? imageByte;

  Reference? ref;

  Gender? _gender;
  Age? _age;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> users = [];

  void setData() async {
    var u = await FirestoreServices.getAllUsers();
    users.addAll(u);
  }

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(
      imageUrl,
      (int _) => ImageElement()..src = imageUrl,
    );
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: !getComplete
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                                  labelText: "عنوان الدورة",
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
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "تفاصيل الدورة",
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
                            const SizedBox(height: 15),
                            Container(
                              width: 610,
                              child: Text(
                                "الفئات المستهدفة:",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text("الذكور"),
                                      leading: Radio<Gender>(
                                        value: Gender.Male,
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          setState(() {
                                            _gender = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text("الإناث"),
                                      leading: Radio<Gender>(
                                        value: Gender.Female,
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          setState(() {
                                            _gender = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text("الأعمار اقل من 20"),
                                      leading: Radio<Age>(
                                        value: Age.lessThan20,
                                        groupValue: _age,
                                        onChanged: (value) {
                                          setState(() {
                                            _age = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text("الأعمار بين 20 و 40"),
                                      leading: Radio<Age>(
                                        value: Age.between20and40,
                                        groupValue: _age,
                                        onChanged: (value) {
                                          setState(() {
                                            _age = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text("الأعمار اكبر من 40"),
                                      leading: Radio<Age>(
                                        value: Age.moreThan40,
                                        groupValue: _age,
                                        onChanged: (value) {
                                          setState(() {
                                            _age = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            createRow('الحالة الإجتماعية : ',
                                _dropDownMenuItems, socialStatus),
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
                                        style:
                                            TextStyle(color: Colors.deepPurple),
                                      ),
                                    ),
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                          height: size.height * .3,
                                          padding: const EdgeInsets.all(4),
                                          child: HtmlElementView(
                                            viewType: imageUrl,
                                          )
                                          /* Image.memory(
                                          imageByte ?? Uint8List.fromList([]),
                                          fit: BoxFit.fill,
                                        ),*/
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
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.deepPurple)),
                                onPressed: () async {
                                  await updateCourse(context);
                                },
                                child: const Text(
                                  "حفظ التغيرات",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ])),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  updateCourse(context) async {
    List<String> tokens = [];
    var g = "";
    var s = socialStatus;
    var a = "";
    if (_gender == Gender.Male) {
      g = "ذكر";
    } else {
      g = "أنثى";
    }
    if (_age == Age.lessThan20) {
      a = "lessThan20";
    } else if (_age == Age.between20and40) {
      a = "between20and40";
    } else {
      a = "moreThan40";
    }
    for (var user in users) {
      var d = (user.get("dateOFBirth") as Timestamp).toDate();
      var userAge = _calculateAge(d);
      var ageLimit = '';
      if (userAge < 20) {
        ageLimit = "lessThan20";
      } else if (40 > userAge && userAge > 20) {
        ageLimit = "between20and40";
      } else {
        ageLimit = "moreThan40";
      }
      if (user.get('gender').toString() == g ||
          user.get('socialStatus').toString() == s ||
          ageLimit == a) {
        var token = user.get("token").toString();
        if (token.isNotEmpty && token != "") {
          tokens.add(token);
        }
      }
    }

    if (imageUrl.isEmpty && videoUrl.text.isEmpty)
      return AwesomeDialog(
          width: MediaQuery.of(context).size.width * .3,
          context: context,
          title: "هام",
          body: Text("يجب إضافة صورةأو رابط لفيديو توضيحي   "),
          dialogType: DialogType.ERROR)
        ..show();
    var formData = formState.currentState;
    if (formData!.validate()) {
      showLoading(context);
      formData.save();
      await FirebaseFirestore.instance
          .collection('centers')
          .doc('renawi')
          .collection('courses')
          .doc(widget.courseId)
          .update({
        "title": title.text,
        "describe": content.text,
        "image": imageUrl,
        'videoLink': videoUrl.text,
        'createdAt': Timestamp.now(),
        'gender': g,
        'age': a,
        'social': s
      }).then((value) async {
        await PushNotification.sendNotification(
            tokens, title.text, "دورة جديدة");
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(MyHomePage.route);
      }).catchError((e) {
        AwesomeDialog(
            context: context,
            title: "خطأ",
            body: Text(e.toString()),
            dialogType: DialogType.ERROR)
          ..show();
      });
    }
  }

  Widget createRow(
    String Status,
    List<DropdownMenuItem<String>> choices,
    String selected,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(Status),
          Spacer(),
          DropdownButton(
            value: selected,
            items: choices,
            onChanged: (String? selectedStatus) {
              setState(() {
                socialStatus = selectedStatus!;
              });
            },
          ),
        ],
      ),
    );
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
