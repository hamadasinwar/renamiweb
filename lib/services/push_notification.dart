import 'dart:convert';
import 'package:http/http.dart';

const _appID = "52eaf4c0-2fdc-4547-8efa-0ba451437a48";

class PushNotification{
  static Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading, String image) async{

    var response = await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": _appID,
        "android_channel_id": 'ec3de920-945a-4661-bc49-017d207e810a',
        "include_player_ids": tokenIdList,
        "android_accent_color":"FF9976D2",
        "small_icon":"ic_launcher",
        "big_picture": image,
        "headings": {"en": heading},
        "contents": {"en": contents},
      }),
    );

    //print("Response: ${response.body}");

    return response;
  }
}