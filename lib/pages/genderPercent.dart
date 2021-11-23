import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GenderPercent extends StatefulWidget {
  @override
  _GenderPercentState createState() => _GenderPercentState();
}

class _GenderPercentState extends State<GenderPercent> {
  late int female;
  late double femalePercent = 0;
  late double malePercent = 0;
  late int numUsers;
  double percent = 0.0;
  getPrecent() async {
    var users = FirebaseFirestore.instance
        .collection('centers')
        .doc('renawi')
        .collection('users');
    users.get().then((value) {
      setState(() {
        numUsers = value.docs.length;
      });
    }).then((_) {
      users.where('gender', isEqualTo: 'أنثى').get().then((value) {
        setState(() {
          female = value.docs.length;
        });
      }).then((_) {
        setState(() {
          percent = female / numUsers;
          femalePercent = percent * 100;
          malePercent = (1 - percent) * 100;
        });
      });
    });
  }

  @override
  void initState() {
    getPrecent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.height * .05,
      ),
      child: Center(
        child: new CircularPercentIndicator(
          radius: 120.0,
          lineWidth: 13.0,
          animation: true,
          percent: percent,
          footer: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.purple, border: Border.all(width: 1.0)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "نسبة الإناث : ",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "$femalePercent%",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.black, width: 1.0)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "نسبة الذكور : ",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "$malePercent%",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                ],
              ),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildSquare(Color color) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black, width: 3.0)),
        ),
      ),
    );
  }
}
