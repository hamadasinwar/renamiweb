import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices{
  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllUsers()async{
    var query = await FirebaseFirestore.instance.collection("users").get();
    return query.docs;
  }
}