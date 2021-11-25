import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices{
  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllUsers()async{
    var query = await FirebaseFirestore.instance.collection("centers").doc('renawi').collection('users').get();
    return query.docs;
  }

  static Future<List<String>> getAllTokens()async{
    List<String> tokens = [];
    var query = await FirebaseFirestore
        .instance.collection("centers")
        .doc('renawi').collection('users')
        .get();
    for(var doc in query.docs){
      tokens.add(doc.get('token'));
    }
    return tokens;
  }
}