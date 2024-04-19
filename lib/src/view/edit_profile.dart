import 'dart:io';
import 'package:clothsonrent/src/view/profile.dart';
import 'package:clothsonrent/src/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/uitilities.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection("users");
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

  Future<void> _saveProfile() async {
    setState(() {
      loading = true;
    });
    try {
      String imagePath = '';
      if (_image != null) {
        final Reference ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${_auth.currentUser!.uid}.jpg');
        final UploadTask uploadTask = ref.putFile(_image!);
        final TaskSnapshot taskSnapshot = await uploadTask;
        imagePath = await taskSnapshot.ref.getDownloadURL();
      }

      final user = _auth.currentUser;
      if (user != null) {
        // Check if user exists
        final userDoc = await firestore.doc(user.uid).get();
        if (userDoc.exists) {
          // Update user if exists
          await userDoc.reference.update({
            'name': _nameController.text,
            'address': _addressController.text,
            'imagePath': imagePath,
          });
        } else {
          // Add new user if not exists
          await userDoc.reference.set({
            'name': _nameController.text,
            'address': _addressController.text,
            'imagePath': imagePath,
          });
        }
      }
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
      setState(() {
        loading = false;
      });
    } catch (e) {
      Utils().toastMessage('Failed to save profile: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.deepPurple,
              size: 30.0,
            ),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          title: const Text("Update Profile", style:TextStyle(fontSize: 25.0, color: Colors.deepPurple),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                              backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/images/dummy-profile2.jpg') as ImageProvider,),
                            if (_image != null)
                              Positioned(
                                top: 130,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,),
                                  child: const Icon(Icons.person),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Text('Tap to upload/update your image'),
                      SizedBox(height: 5.h),
                      Text('$_userPhoneNumber',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      SizedBox(height: 30.h),
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: "Name",
                        hintText: "Enter Your Name",
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        maxline: 3,
                        controller: _addressController,
                        labelText: "Address",
                        hintText: "Enter Your Address",
                        keyboardType: TextInputType.streetAddress,
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding:  EdgeInsets.only(left:130.w),
                        child: SizedBox(
                          height: 50.h,
                          width: 230.w,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                            ),
                            child: Center(
                              child: loading
                                  ? const CircularProgressIndicator(
                                strokeWidth: 3,
                              )
                                  : const Text("Save"),
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
      ),
    );
  }
}
