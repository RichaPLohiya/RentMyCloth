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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/uitilities.dart';
import '../widgets/bottomnavigationbar.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String? updatedImagePath;

  const ProfileScreen({Key? key, this.updatedImagePath}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  String? _userPhoneNumber;
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    _getUserPhoneNumber();
    _getUserData();
    _localImagePath = widget.updatedImagePath;
  }

  Future<void> _getUserPhoneNumber() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userPhoneNumber = user.phoneNumber;
      });
    }
  }

  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userPhoneNumber = user.phoneNumber;
          final imagePath = userDoc.get('imagePath');
          if (imagePath != null) {
            _downloadImage(imagePath);
          }
        });
      }
    }
  }

  Future<void> _downloadImage(String imagePath) async {
    try {
      final String fileName = imagePath.split('/').last;
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/$fileName');

      if (await tempFile.exists()) {
        setState(() {
          _localImagePath = tempFile.path;
        });
      } else {
        final HttpClient httpClient = HttpClient();
        final Uri uri = Uri.parse(imagePath);
        final HttpClientRequest request = await httpClient.getUrl(uri);
        final HttpClientResponse response = await request.close();

        if (response.statusCode == 200) {
          await response.pipe(tempFile.openWrite());
          setState(() {
            _localImagePath = tempFile.path;
          });
        } else {
          throw Exception('Failed to download image: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Widget _buildProfileImage() {
    if (_localImagePath != null && File(_localImagePath!).existsSync()) {
      return CircleAvatar(
        radius: 90,
        backgroundImage: FileImage(File(_localImagePath!)),
      );
    } else {
      return CircleAvatar(
        radius: 90,
        backgroundImage: AssetImage('assets/images/dummy-profile2.jpg'),
      );
    }
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      _buildProfileImage(),
                    ],
                  ),
                ),
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
                              builder: (context) => const EditProfileScreen(),
                            ),
                          ).then((value) {
                            // Refresh profile screen after editing profile
                            _getUserData();
                          });
                        },
                        child: const Text("Edit Profile"),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const NotificationScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.deepPurple,
                                              )
                                            ]),
                                        child: const Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      const Text("My Request"),
                                      SizedBox(
                                        width: 155.w,
                                      ),
                                      Icon(
                                        Icons.chevron_right_sharp,
                                        color: Colors.deepPurple,
                                        size: 25.0,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const MyCartScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.deepPurple,
                                              )
                                            ]),
                                        child: const Icon(
                                          Icons.shopping_cart,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      const Text("My Cart"),
                                      SizedBox(
                                        width: 175.w,
                                      ),
                                      const Icon(
                                        Icons.chevron_right_sharp,
                                        color: Colors.deepPurple,
                                        size: 25.0,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const FAQsScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.deepPurple,
                                              )
                                            ]),
                                        child: const Icon(
                                          Icons.help,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      const Text("FAQs"),
                                      SizedBox(
                                        width: 190.w,
                                      ),
                                      const Icon(
                                        Icons.chevron_right_sharp,
                                        color: Colors.deepPurple,
                                        size: 25.0,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const PrivacyPolicyScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.deepPurple,
                                              )
                                            ]),
                                        child: const Icon(
                                          Icons.policy,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      const Text("Privacy Policy"),
                                      SizedBox(
                                        width: 140.w,
                                      ),
                                      const Icon(
                                        Icons.chevron_right_sharp,
                                        color: Colors.deepPurple,
                                        size: 25.0,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const TermsAndConditionsScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.deepPurple,
                                              )
                                            ]),
                                        child: const Icon(
                                          Icons.description_outlined,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      const Text("Terms and Condition"),
                                      SizedBox(
                                        width: 100.w,
                                      ),
                                      const Icon(
                                        Icons.chevron_right_sharp,
                                        color: Colors.deepPurple,
                                        size: 25.0,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _auth.signOut().then((value) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const LoginScreen()));
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
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.deepPurple,
                                              )
                                            ]),
                                        child: const Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      const Text("Logout"),
                                      SizedBox(
                                        width: 180.w,
                                      ),
                                      const Icon(
                                        Icons.chevron_right_sharp,
                                        color: Colors.deepPurple,
                                        size: 25.0,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
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
