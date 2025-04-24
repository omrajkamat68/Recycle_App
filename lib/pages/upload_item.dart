import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:recycle_app/services/database.dart';
import 'package:recycle_app/services/shared_pref.dart';
import 'package:recycle_app/services/widget_support.dart';

class UploadItem extends StatefulWidget {
  String category, id;
  UploadItem({required this.category, required this.id});

  @override
  State<UploadItem> createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  TextEditingController addresscontroller = new TextEditingController();
  TextEditingController quantitycontroller = new TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? id, name;

  getthesharedpref() async {
    id = await SharedpreferenceHelper().getUserId();
    name = await SharedpreferenceHelper().getUserName();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getthesharedpref();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  SizedBox(width: MediaQuery.of(context).size.width / 5.5),
                  Text("Upload Item", style: AppWidget.headlinetextstyle(25.0)),
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
                    SizedBox(height: 30.0),
                    selectedImage != null
                        ? Center(
                          child: Container(
                            height: 180,
                            width: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        : GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Enter your Address you want the item to be picked.",
                        style: AppWidget.normaltextstyle(18.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: addresscontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                              hintText: "Enter Address",
                              hintStyle: AppWidget.normaltextstyle(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Enter the Quantity of item to be picked.",
                        style: AppWidget.normaltextstyle(18.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: quantitycontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.inventory,
                                color: Colors.green,
                              ),
                              hintText: "Enter Quantity",
                              hintStyle: AppWidget.normaltextstyle(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 60.0),
                    GestureDetector(
                      onTap: () async {
                        if (
                            addresscontroller.text != "" &&
                            quantitycontroller.text != "") {
                          String itemid = randomAlphaNumeric(10);
                          // Reference firebaseStorageRef = FirebaseStorage
                          //     .instance
                          //     .ref()
                          //     .child("blogImage")
                          //     .child(itemid);
                          // final UploadTask task = firebaseStorageRef.putFile(
                          //   selectedImage!,
                          // );
                          // var downloadUrl =
                          //     await (await task).ref.getDownloadURL();

                          Map<String, dynamic> addItem = {
                            "Image": "",
                            "Address": addresscontroller.text,
                            "Quantity": quantitycontroller.text,
                            "UserId": id,
                            "Name": name,
                            "Status": "Pending",
                          };
                          await DatabaseMethods().addUserUploadItem(
                            addItem,
                            id!,
                            itemid,
                          );
                          await DatabaseMethods().addAdminItem(addItem, itemid);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Item has been uploaded Successfully!",
                                style: AppWidget.whitetextstyle(22.0),
                              ),
                            ),
                          );
                          setState(() {
                            addresscontroller.text = "";
                            quantitycontroller.text = "";
                            selectedImage = null;
                          });
                        }
                      },
                      child: Center(
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Upload",
                                style: AppWidget.whitetextstyle(26.0),
                              ),
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







// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:random_string/random_string.dart';
// import 'package:recycle_app/services/database.dart';
// import 'package:recycle_app/services/shared_pref.dart';
// import 'package:recycle_app/services/widget_support.dart';

// class UploadItem extends StatefulWidget {
//   final String category, id;
//   UploadItem({required this.category, required this.id});

//   @override
//   State<UploadItem> createState() => _UploadItemState();
// }

// class _UploadItemState extends State<UploadItem> {
//   TextEditingController addresscontroller = TextEditingController();
//   TextEditingController quantitycontroller = TextEditingController();

//   final ImagePicker _picker = ImagePicker();
//   File? selectedImage;
//   String? id, name;

//   getthesharedpref() async {
//     id = await SharedpreferenceHelper().getUserId();
//     name = await SharedpreferenceHelper().getUserName();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     getthesharedpref();
//   }

//   Future getImage() async {
//     final image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       selectedImage = File(image.path);
//       setState(() {});
//     }
//   }

//   Future uploadItem() async {
//     if (selectedImage == null || !selectedImage!.existsSync()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("Please select a valid image."),
//         ),
//       );
//       return;
//     }

//     if (addresscontroller.text.isEmpty || quantitycontroller.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("Please enter address and quantity."),
//         ),
//       );
//       return;
//     }

//     try {
//       String itemid = randomAlphaNumeric(10);
//       String filePath = "uploads/${id!}/$itemid.jpg";
//       print("Uploading to: $filePath");

//       Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
//       UploadTask uploadTask = storageRef.putFile(selectedImage!);

//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       print("Download URL: $downloadUrl");

//       Map<String, dynamic> itemData = {
//         "Image": downloadUrl,
//         "Address": addresscontroller.text,
//         "Quantity": quantitycontroller.text,
//         "UserId": id,
//         "Name": name,
//       };

//       await DatabaseMethods().addUserUploadItem(itemData, id!, itemid);
//       await DatabaseMethods().addAdminItem(itemData, itemid);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.green,
//           content: Text("Item uploaded successfully!"),
//         ),
//       );

//       setState(() {
//         selectedImage = null;
//         addresscontroller.clear();
//         quantitycontroller.clear();
//       });
//     } catch (e) {
//       print("Upload failed: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("Upload failed: $e"),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Material(
//                       elevation: 3.0,
//                       borderRadius: BorderRadius.circular(60),
//                       color: Colors.black,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Icon(Icons.arrow_back_ios_new_rounded,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   Spacer(),
//                   Text("Upload Item",
//                       style: AppWidget.headlinetextstyle(24.0)),
//                   Spacer(flex: 2),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFececf8),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//                 ),
//                 padding: const EdgeInsets.all(20),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       selectedImage != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(20),
//                               child: Image.file(
//                                 selectedImage!,
//                                 height: 180,
//                                 width: 180,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : GestureDetector(
//                               onTap: getImage,
//                               child: Container(
//                                 height: 180,
//                                 width: 180,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(color: Colors.black45),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Icon(Icons.camera_alt_outlined, size: 30),
//                               ),
//                             ),
//                       SizedBox(height: 30),
//                       buildInputField(
//                         icon: Icons.location_on,
//                         controller: addresscontroller,
//                         hint: "Enter Address",
//                       ),
//                       SizedBox(height: 20),
//                       buildInputField(
//                         icon: Icons.inventory,
//                         controller: quantitycontroller,
//                         hint: "Enter Quantity",
//                       ),
//                       SizedBox(height: 40),
//                       GestureDetector(
//                         onTap: uploadItem,
//                         child: Container(
//                           height: 60,
//                           width: MediaQuery.of(context).size.width / 1.5,
//                           decoration: BoxDecoration(
//                             color: Colors.green,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Center(
//                             child: Text("Upload",
//                                 style: AppWidget.whitetextstyle(26.0)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildInputField({
//     required IconData icon,
//     required TextEditingController controller,
//     required String hint,
//   }) {
//     return Material(
//       elevation: 2.0,
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             prefixIcon: Icon(icon, color: Colors.green),
//             hintText: hint,
//             hintStyle: AppWidget.normaltextstyle(18.0),
//           ),
//         ),
//       ),
//     );
//   }
// }
