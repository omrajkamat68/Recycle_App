import 'package:flutter/material.dart';
import 'package:recycle_app/services/widget_support.dart';

class AdminReedem extends StatefulWidget {
  const AdminReedem({super.key});

  @override
  State<AdminReedem> createState() => _AdminReedemState();
}

class _AdminReedemState extends State<AdminReedem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(60),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 7),
                  Text(
                    "Redeem Approval",
                    style: AppWidget.headlinetextstyle(25.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Color(0xFFececf8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0,),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          child: Text("22\nMar",
                          textAlign: TextAlign.center,
                          style: AppWidget.whitetextstyle(22.0),),
                        ),
                        SizedBox(width: 20.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(children: [
                            Icon(Icons.person, color: Colors.green, size: 25.0,),
                            SizedBox(width: 10.0,),
                            Text("Ayush Gupta", style: AppWidget.normaltextstyle(18.0),)
                          ],),
                          Row(children: [
                            Icon(Icons.point_of_sale, color: Colors.green, size: 25.0,),
                            SizedBox(width: 10.0,),
                            Text("Points Redeem : 10", style: AppWidget.normaltextstyle(18.0),)
                          ],),
                          Row(children: [
                            Icon(Icons.monetization_on, color: Colors.green, size: 25.0,),
                            SizedBox(width: 10.0,),
                            Text("UPI ID : ggggg@oksbi", style: AppWidget.normaltextstyle(18.0),)
                          ],),
                          SizedBox(height: 5.0,),
                          Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("Approved", style: AppWidget.whitetextstyle(18.0),)),
                          )
                        ],)
                      ],),
                    )
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
