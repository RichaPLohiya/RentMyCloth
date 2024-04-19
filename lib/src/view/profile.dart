import 'dart:io';
import 'package:clothsonrent/src/ui/authentication/login_screen.dart';
import 'package:clothsonrent/src/view/edit_profile.dart';
import 'package:clothsonrent/src/view/faqsscreen.dart';
import 'package:clothsonrent/src/view/mycart.dart';
import 'package:clothsonrent/src/view/notificationscreen.dart';
import 'package:clothsonrent/src/view/privacypolicyscreen.dart';
import 'package:clothsonrent/src/view/putonrent.dart';
import 'package:clothsonrent/src/view/terms&conditionscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/uitilities.dart';
import '../widgets/bottomnavigationbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  final firestore = FirebaseFirestore.instance;
  File? _image;
  final picker = ImagePicker();
  String? _userPhoneNumber;

  @override
  void initState() {
    super.initState();
    _getUserPhoneNumber();
  }

  Future<void> _getUserPhoneNumber() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userPhoneNumber = user.phoneNumber;
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _showImagePickerDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload your image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Upload from Gallery'),
                  onTap: () {
                    _getImageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: const Text('Upload from Camera'),
                  onTap: () {
                    _getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 25.0, color: Colors.deepPurple),
          ),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       _auth.signOut().then((value) {
          //         Navigator.pushReplacement(
          //             context,
          //             MaterialPageRoute(
          //              builder: (context) => const LoginScreen()));
          //       }).onError((error, stackTrace) {
          //         Utils().toastMessage(error.toString());
          //       });
          //     },
          //     icon: const Icon(
          //       Icons.logout_outlined,
          //       color: Colors.deepPurple,
          //       size: 25.0,
          //     ),
          //   ),
          //   SizedBox(width: 10.w)
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _showImagePickerDialog,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 90,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : const AssetImage(
                                          'assets/images/dummy-profile2.jpg')
                                      as ImageProvider,
                            ),
                            if (_image != null)
                              Positioned(
                                top: 130.h,
                                right: 10.w,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Text('Tap to upload/update your image'),
                      SizedBox(height: 10.h),
                      Text(
                        '${_userPhoneNumber}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          SizedBox(
                            height: 50.h,
                            width: 160.w,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PutOnRent(),
                                  ),
                                );
                              },
                              child: const Text("Upload On Rent"),
                            ),
                          ),
                          SizedBox(
                            width: 20.h,
                          ),
                          SizedBox(
                            height: 50.h,
                            width: 160.w,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfileScreen(),
                                  ),
                                );
                              },
                              child: const Text("Edit Profile"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 350,
                          height: 330,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2,),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10.h,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen(),),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30.w,
                                          height: 30.h,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [const BoxShadow(color: Colors.deepPurple,)]),
                                          child: const Icon(Icons.notifications, color: Colors.white, size: 25.0),
                                        ),
                                      SizedBox(width: 10.w,),
                                      const Text("My Request"),
                                      SizedBox(width: 155.w,),
                                      Icon(Icons.chevron_right_sharp,color: Colors.deepPurple, size: 25.0,),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCartScreen()),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [const BoxShadow(color: Colors.deepPurple,)]),
                                        child: const Icon(Icons.shopping_cart, color: Colors.white, size: 25.0),
                                      ),
                                      SizedBox(width: 10.w,),
                                      const Text("My Cart"),
                                      SizedBox(width: 175.w,),
                                      const Icon(Icons.chevron_right_sharp,color: Colors.deepPurple, size: 25.0,),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                                GestureDetector(
                                  onTap:(){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQsScreen(),),);
                                  } ,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [const BoxShadow(color: Colors.deepPurple,)]),
                                        child: const Icon(Icons.help, color: Colors.white, size: 25.0),
                                      ),
                                      SizedBox(width: 10.w,),
                                      const Text("FAQs"),
                                      SizedBox(width: 190.w,),
                                      const Icon(Icons.chevron_right_sharp,color: Colors.deepPurple, size: 25.0,),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen(),),);

                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [const BoxShadow(color: Colors.deepPurple,)]),
                                        child: const Icon(Icons.policy, color: Colors.white, size: 25.0),
                                      ),
                                      SizedBox(width: 10.w,),
                                      const Text("Privacy Policy"),
                                      SizedBox(width: 140.w,),
                                      const Icon(Icons.chevron_right_sharp,color: Colors.deepPurple, size: 25.0,),
                                                                          ],
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen(),),);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [const BoxShadow(color: Colors.deepPurple,)]),
                                        child: const Icon(Icons.description_outlined, color: Colors.white, size: 25.0),
                                      ),
                                      SizedBox(width: 10.w,),
                                      const Text("Terms and Condition"),
                                      SizedBox(width: 100.w,),
                                      const Icon(Icons.chevron_right_sharp,color: Colors.deepPurple, size: 25.0,),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                                GestureDetector(
                                  onTap: (){
                                    _auth.signOut().then((value) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const LoginScreen()));
                                    }).onError((error, stackTrace) {
                                      Utils().toastMessage(error.toString());
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [const BoxShadow(color: Colors.deepPurple,)]),
                                        child: const Icon(Icons.logout, color: Colors.white, size: 25.0),
                                      ),
                                      SizedBox(width: 10.w,),
                                      const Text("Logout"),
                                      SizedBox(width: 180.w,),
                                       const Icon(Icons.chevron_right_sharp,color: Colors.deepPurple, size: 25.0,),
                                                                        ],
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(
          currentIndex: 3,
        ),
      ),
    );
  }
}
