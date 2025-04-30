import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:recycle_app/services/database.dart';
import 'package:recycle_app/services/shared_pref.dart';
import 'package:recycle_app/services/widget_support.dart';

class Points extends StatefulWidget {
  const Points({super.key});

  @override
  State<Points> createState() => _PointsState();
}

class _PointsState extends State<Points> {
  String? id, mypoints, name;
  Stream? pointsStream;

  getthesharedpref() async {
    id = await SharedpreferenceHelper().getUserId();
    name = await SharedpreferenceHelper().getUserName();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    mypoints = await getUserPoints(id!);
    pointsStream = await DatabaseMethods().getUserTransactions(id!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  TextEditingController pointscontroller = new TextEditingController();
  TextEditingController upicontroller = new TextEditingController();

  Future<String> getUserPoints(String docId) async {
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(docId).get();

      if (docSnapshot.exists) {
        // Get 'userpoints' field as String (convert if it's int)
        var data = docSnapshot.data() as Map<String, dynamic>;
        var points = data['Points'];
        return points.toString();
      } else {
        return 'No document';
      }
    } catch (e) {
      print('Error: $e');
      return 'Error';
    }
  }

  Widget allApprovals() {
    return StreamBuilder(
      stream: pointsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 20.0,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 233, 233, 249),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ds["Date"],
                          textAlign: TextAlign.center,
                          style: AppWidget.whitetextstyle(22.0),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        children: [
                          Text(
                            "Redeem Points",
                            style: AppWidget.normaltextstyle(20.0),
                          ),
                          Text(
                            ds["Points"],
                            style: AppWidget.greentextstyle(26.0),
                          ),
                        ],
                      ),
                      SizedBox(width: 20.0),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              ds["Status"] == "Approved"
                                  ? const Color.fromARGB(78, 76, 175, 79)
                                  : const Color.fromARGB(48, 241, 77, 66),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ds["Status"],
                          style: TextStyle(
                            color:
                                ds["Status"] == "Approved"
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          mypoints == null
              ? Center(child: CircularProgressIndicator())
              : Container(
                margin: EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Points Page",
                        style: AppWidget.headlinetextstyle(28.0),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 233, 249),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30.0),
                            Container(
                              margin: EdgeInsets.only(left: 50.0, right: 50.0),
                              child: Material(
                                elevation: 3.0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.all(15),

                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10.0),
                                      Image.asset(
                                        "images/coin.png",
                                        height: 70,
                                        width: 70,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 30.0),
                                      Column(
                                        children: [
                                          Text(
                                            "Points Earned",
                                            style: AppWidget.normaltextstyle(
                                              20.0,
                                            ),
                                          ),
                                          Text(
                                            mypoints.toString(),
                                            style: AppWidget.greentextstyle(
                                              30.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            GestureDetector(
                              onTap: () {
                                openBox();
                              },
                              child: Material(
                                elevation: 2.0,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Center(
                                    child: Text(
                                      "Redeem Points",
                                      style: AppWidget.whitetextstyle(23.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Last Transactions",
                                      style: AppWidget.normaltextstyle(22.0),
                                    ),
                                    SizedBox(height: 20.0),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                          2,
                                      child: allApprovals(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Future openBox() => showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel),
                      ),
                      SizedBox(width: 30.0),
                      Text(
                        "Redeem Points",
                        style: AppWidget.greentextstyle(20.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text("Add Points", style: AppWidget.normaltextstyle(20.0)),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: pointscontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Points",
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text("Add UPI Id", style: AppWidget.normaltextstyle(20.0)),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: upicontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter UPI",
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () async {
                      if (pointscontroller.text != "" &&
                          upicontroller.text != "" &&
                          int.parse(mypoints!) >
                              int.parse(pointscontroller.text)) {
                        DateTime now = DateTime.now();
                        String formattedDate = DateFormat('d\nMMM').format(now);
                        int updatedpoints =
                            int.parse(mypoints!) -
                            int.parse(pointscontroller.text);
                        await DatabaseMethods().updateUserPoints(
                          id!,
                          updatedpoints.toString(),
                        );

                        Map<String, dynamic> userReedemMap = {
                          "Name": name,
                          "Points": pointscontroller.text,
                          "UPI": upicontroller.text,
                          "Status": "Pending",
                          "Date": formattedDate,
                          "UserId": id,
                        };
                        String reedemid = randomAlphaNumeric(10);
                        await DatabaseMethods().addUserReedemPoints(
                          userReedemMap,
                          id!,
                          reedemid,
                        );
                        await DatabaseMethods().addAdminReedemRequests(
                          userReedemMap,
                          reedemid,
                        );
                        mypoints = await getUserPoints(id!);
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFF008080),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Add",
                            style: AppWidget.whitetextstyle(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
