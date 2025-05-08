import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recycle_app/services/database.dart';
import 'package:recycle_app/services/widget_support.dart';

class AdminApproval extends StatefulWidget {
  const AdminApproval({super.key});

  @override
  State<AdminApproval> createState() => _AdminApprovalState();
}

class _AdminApprovalState extends State<AdminApproval> {
  Stream? approvalStream;

  getontheload() async {
    approvalStream = await DatabaseMethods().getAdminApproval();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Future<String> getUserPoints(String docId) async {
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(docId).get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        var points = data['Points'];
        return points.toString();
      } else {
        return '0';
      }
    } catch (e) {
      print('Error: $e');
      return '0';
    }
  }

  Widget allApprovals() {
    return StreamBuilder(
      stream: approvalStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No approvals yet."));
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            final data = ds.data() as Map<String, dynamic>;

            // Use "Points" if present, otherwise use "Quantity"
            final String pointsStr =
                data.containsKey("Points")
                    ? data["Points"].toString()
                    : (data.containsKey("Quantity")
                        ? data["Quantity"].toString()
                        : "0");
            final int pointsToAdd = int.tryParse(pointsStr) ?? 0;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.recycling,
                          size: 60,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                  size: 28.0,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  data["Name"] ?? "",
                                  style: AppWidget.normaltextstyle(20.0),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 28.0,
                                ),
                                const SizedBox(width: 10.0),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    data["Address"] ?? "",
                                    style: AppWidget.normaltextstyle(20.0),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.inventory,
                                  color: Colors.green,
                                  size: 28.0,
                                ),
                                const SizedBox(width: 10.0),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    data["Quantity"]?.toString() ?? "",
                                    style: AppWidget.normaltextstyle(20.0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final userId = data["UserId"];
                                  // If this is a redemption request, only update status, do NOT add points!
                                  if (data.containsKey("UPI")) {
                                    // Redemption: do not add points, just mark as approved
                                    await DatabaseMethods().updateAdminRequest(
                                      ds.id,
                                    );
                                    await DatabaseMethods().updateUserRequest(
                                      userId,
                                      ds.id,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Redemption approved."),
                                      ),
                                    );
                                  } else {
                                    // Regular approval: add points
                                    String userpoints = await getUserPoints(
                                      userId,
                                    );
                                    int updatedpoints =
                                        int.parse(userpoints) + pointsToAdd;
                                    await DatabaseMethods().updateUserPoints(
                                      userId,
                                      updatedpoints.toString(),
                                    );
                                    await DatabaseMethods().updateAdminRequest(
                                      ds.id,
                                    );
                                    await DatabaseMethods().updateUserRequest(
                                      userId,
                                      ds.id,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Approved and points updated.",
                                        ),
                                      ),
                                    );
                                  }
                                  getontheload();
                                } catch (e) {
                                  print("Approval error: $e");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                }
                              },
                              child: Container(
                                height: 40,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Approve",
                                    style: AppWidget.whitetextstyle(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 7),
                  Text(
                    "Admin Approval",
                    style: AppWidget.headlinetextstyle(25.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: Color(0xFFececf8),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Expanded(child: allApprovals()),
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
