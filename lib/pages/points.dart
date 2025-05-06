// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:random_string/random_string.dart';
// import 'package:recycle_app/services/database.dart';
// import 'package:recycle_app/services/shared_pref.dart';
// import 'package:recycle_app/services/widget_support.dart';

// class Points extends StatefulWidget {
//   const Points({super.key});

//   @override
//   State<Points> createState() => _PointsState();
// }

// class _PointsState extends State<Points> {
//   String? id, name;
//   Stream? pointsStream;
//   Stream<DocumentSnapshot>? userPointsStream;

//   getthesharedpref() async {
//     id = await SharedpreferenceHelper().getUserId();
//     name = await SharedpreferenceHelper().getUserName();
//     setState(() {});
//   }

//   ontheload() async {
//     await getthesharedpref();
//     userPointsStream =
//         FirebaseFirestore.instance.collection('users').doc(id).snapshots();
//     pointsStream = await DatabaseMethods().getUserTransactions(id!);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     ontheload();
//   }

//   TextEditingController pointscontroller = TextEditingController();
//   TextEditingController upicontroller = TextEditingController();

//   Widget allApprovals() {
//     return StreamBuilder(
//       stream: pointsStream,
//       builder: (context, AsyncSnapshot snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.data.docs.length == 0) {
//           return const Center(child: Text("No transactions yet."));
//         }
//         List<DocumentSnapshot> sortedDocs = List.from(snapshot.data.docs);
//         sortedDocs.sort((a, b) {
//           if (a['Status'] == 'Pending' && b['Status'] != 'Pending') return -1;
//           if (a['Status'] != 'Pending' && b['Status'] == 'Pending') return 1;
//           return 0;
//         });

//         return ListView.builder(
//           padding: EdgeInsets.zero,
//           itemCount: sortedDocs.length,
//           itemBuilder: (context, index) {
//             DocumentSnapshot ds = sortedDocs[index];
//             return Container(
//               padding: const EdgeInsets.all(10),
//               margin: const EdgeInsets.only(
//                 left: 20.0,
//                 right: 20.0,
//                 bottom: 20.0,
//               ),
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 233, 233, 249),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   // Date Box
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           ds["Date"].split("\n")[0],
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           ds["Date"].split("\n")[1],
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 20.0),
//                   // Points Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Redeem Points",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           ds["Points"],
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Status Badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 6,
//                       horizontal: 14,
//                     ),
//                     decoration: BoxDecoration(
//                       color:
//                           ds["Status"] == "Approved"
//                               ? const Color.fromARGB(78, 76, 175, 79)
//                               : const Color.fromARGB(48, 241, 77, 66),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       ds["Status"],
//                       style: TextStyle(
//                         color:
//                             ds["Status"] == "Approved"
//                                 ? Colors.green
//                                 : Colors.red,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           id == null
//               ? const Center(child: CircularProgressIndicator())
//               : Container(
//                 margin: const EdgeInsets.only(top: 40.0),
//                 child: Column(
//                   children: [
//                     Center(
//                       child: Text(
//                         "Points Page",
//                         style: AppWidget.headlinetextstyle(28.0),
//                       ),
//                     ),
//                     const SizedBox(height: 20.0),
//                     Expanded(
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         decoration: const BoxDecoration(
//                           color: Color.fromARGB(255, 233, 233, 249),
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(30),
//                             topRight: Radius.circular(30),
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 30.0),
//                             // Points Earned Card (now using StreamBuilder for real-time updates)
//                             StreamBuilder<DocumentSnapshot>(
//                               stream: userPointsStream,
//                               builder: (context, snapshot) {
//                                 if (!snapshot.hasData) {
//                                   return const Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 }
//                                 var points =
//                                     (snapshot.data?.data()
//                                         as Map<String, dynamic>?)?['Points'] ??
//                                     '0';
//                                 return Container(
//                                   margin: const EdgeInsets.symmetric(
//                                     horizontal: 50.0,
//                                   ),
//                                   child: Material(
//                                     elevation: 3.0,
//                                     borderRadius: BorderRadius.circular(20),
//                                     child: Container(
//                                       padding: const EdgeInsets.all(15),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Image.asset(
//                                             "images/coin.png",
//                                             height: 60,
//                                             width: 60,
//                                             fit: BoxFit.cover,
//                                           ),
//                                           const SizedBox(width: 24.0),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               const Text(
//                                                 "Points Earned",
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 points.toString(),
//                                                 style: const TextStyle(
//                                                   color: Colors.green,
//                                                   fontSize: 28,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(height: 30.0),
//                             GestureDetector(
//                               onTap: () {
//                                 openBox();
//                               },
//                               child: Material(
//                                 elevation: 2.0,
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Container(
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   width:
//                                       MediaQuery.of(context).size.width / 1.5,
//                                   child: Center(
//                                     child: Text(
//                                       "Redeem Points",
//                                       style: AppWidget.whitetextstyle(23.0),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20.0),
//                             Expanded(
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(30),
//                                     topRight: Radius.circular(30),
//                                   ),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const SizedBox(height: 10.0),
//                                     const Text(
//                                       "Last Transactions",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 10.0),
//                                     Expanded(child: allApprovals()),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }

// Future openBox() => showDialog(
//   context: context,
//   builder:
//       (context) => AlertDialog(
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.cancel),
//                   ),
//                   const SizedBox(width: 30.0),
//                   Text(
//                     "Redeem Points",
//                     style: AppWidget.greentextstyle(20.0),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20.0),
//               Text("Add Points", style: AppWidget.normaltextstyle(20.0)),
//               const SizedBox(height: 10.0),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black38, width: 2.0),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextField(
//                   controller: pointscontroller,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: "Enter Points",
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               Text("Add UPI Id", style: AppWidget.normaltextstyle(20.0)),
//               const SizedBox(height: 10.0),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black38, width: 2.0),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextField(
//                   controller: upicontroller,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: "Enter UPI",
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               StreamBuilder<DocumentSnapshot>(
//                 stream: userPointsStream,
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) return const SizedBox.shrink();

//                   final currentPoints =
//                       (snapshot.data?.data()
//                               as Map<String, dynamic>?)?['Points']
//                           ?.toString() ??
//                       '0';
//                   final currentPointsInt = int.tryParse(currentPoints) ?? 0;

//                   return GestureDetector(
//                     onTap: () async {
//                       if (pointscontroller.text.isNotEmpty &&
//                           upicontroller.text.isNotEmpty) {
//                         final redeemPoints =
//                             int.tryParse(pointscontroller.text) ?? 0;

//                         if (redeemPoints <= 0) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Enter valid points amount"),
//                             ),
//                           );
//                           return;
//                         }

//                         if (currentPointsInt < redeemPoints) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Insufficient points"),
//                             ),
//                           );
//                           return;
//                         }

//                         try {
//                           // Update user points
//                           final updatedPoints =
//                               currentPointsInt - redeemPoints;
//                           await DatabaseMethods().updateUserPoints(
//                             id!,
//                             updatedPoints.toString(),
//                           );

//                           // Create redemption request
//                           final redemptionData = {
//                             "Name": name,
//                             "Points": redeemPoints.toString(),
//                             "UPI": upicontroller.text,
//                             "Status": "Pending",
//                             "Date": DateFormat(
//                               'd\nMMM',
//                             ).format(DateTime.now()),
//                             "UserId": id,
//                           };

//                           final redemptionId = randomAlphaNumeric(10);
//                           await DatabaseMethods().addUserReedemPoints(
//                             redemptionData,
//                             id!,
//                             redemptionId,
//                           );
//                           await DatabaseMethods().addAdminReedemRequests(
//                             redemptionData,
//                             redemptionId,
//                           );

//                           // Refresh data
//                           pointscontroller.clear();
//                           upicontroller.clear();
//                           Navigator.pop(context);
//                           ontheload(); // Refresh the points stream
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Error: ${e.toString()}")),
//                           );
//                         }
//                       }
//                     },
//                     child: Center(
//                       child: Container(
//                         width: 100,
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF008080),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Add",
//                             style: AppWidget.whitetextstyle(20.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
// );
// }

import 'package:flutter/material.dart';
import 'package:recycle_app/services/database.dart';
import 'package:recycle_app/services/widget_support.dart';

class Points extends StatefulWidget {
  const Points({super.key});

  @override
  State<Points> createState() => _PointsState();
}

class _PointsState extends State<Points> {
  TextEditingController pointscontroller = new TextEditingController();
  TextEditingController upicontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  color: const Color.fromARGB(255, 233, 233, 249),
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
                                    style: AppWidget.normaltextstyle(20.0),
                                  ),
                                  Text(
                                    "300",
                                    style: AppWidget.greentextstyle(30.0),
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
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Center(
                            child: Text(
                              "Redeem Points",
                              style: AppWidget.whitetextstyle(23.0),
                            ),
                          ),
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
}
