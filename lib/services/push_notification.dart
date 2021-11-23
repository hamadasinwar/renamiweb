import 'dart:convert';
import 'package:http/http.dart';

const _appID = "326493c7-9fc7-4e81-b1b7-dad44e08ff87";

class PushNotification{
  static Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": _appID,
        "include_player_ids": tokenIdList,
        "android_accent_color":"FF9976D2",
        //"small_icon":"ic_stat_onesignal_default",
        //"large_icon":"https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",
        "large_icon":"https://firebasestorage.googleapis.com/v0/b/daburiyya.appspot.com/o/images%2Fimages.jpeg?alt=media&token=464877de-5534-4032-8440-7ae57897b1c4",
        "headings": {"en": heading},
        "contents": {"en": contents},
      }),
    );
  }
}