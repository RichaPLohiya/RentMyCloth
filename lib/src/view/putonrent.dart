import 'dart:io';
import 'package:clothsonrent/src/ui/authentication/login_screen.dart';
import 'package:clothsonrent/src/view/homescreen.dart';
import 'package:clothsonrent/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/uitilities.dart';
import '../widgets/bottomnavigationbar.dart';


class PutOnRent extends StatefulWidget {
  const PutOnRent({super.key});

  @override
  State<PutOnRent> createState() => _PutOnRentState();
}

class _PutOnRentState extends State<PutOnRent> {

  final _auth = FirebaseAuth.instance;
  final TextEditingController _pNameController = TextEditingController();
  final TextEditingController _pBrandController = TextEditingController();
  final TextEditingController _pDescreptionController = TextEditingController();
  final TextEditingController _pUsedController = TextEditingController();
  final TextEditingController _pPriceController = TextEditingController();
  final TextEditingController _pSizeController = TextEditingController();
  final TextEditingController _pTypeController = TextEditingController();
  bool _freeDelivery = false;
  final List<File?> _images = List.filled(3, null);
  final picker = ImagePicker();

  Future<void> _getImageFromGallery(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _images[index] = File(pickedFile.path);
      }
    });
  }
  Future<void> _getImageFromCamera(int index) async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _images[index]  = File(pickedFile.path);
      }
    });
  }
  Future<void> _showImagePickerDialog(int index) async {
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
                    _getImageFromGallery(index);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: const Text('Upload from Camera'),
                  onTap: () {
                    _getImageFromCamera(index);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: const Text('Cancel'),
                  onTap: () {
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
          title: const Text("Upload", style:TextStyle(fontSize: 20.0, color: Colors.deepPurple),),
          centerTitle: true,
        ),

        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/image6.jpg'), // Replace 'assets/background_image.jpg' with your image path
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.9), // Adjust opacity as needed
                BlendMode.lighten,
              ),
            ),
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Stack(
              children : [
               Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _showImagePickerDialog(0),
                            child: Container(
                              width: 100.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _images[0] == null ?
                              const Icon(Icons.add) :
                              Image.file(_images[0]!, fit: BoxFit.cover),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showImagePickerDialog(1),
                            child: Container(
                              width: 100.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _images[1] == null ?
                              const Icon(Icons.add) :
                              Image.file(_images[1]!, fit: BoxFit.cover),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showImagePickerDialog(2),
                            child: Container(
                              width: 100.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _images[2] == null ?
                              const Icon(Icons.add) :
                              Image.file(_images[2]!, fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0.h),
                      CustomTextFormField(
                        controller: _pNameController,
                        labelText: "Product Name",
                        hintText: "Enter Product Name",
                        keyboardType: TextInputType.name,
                      ),
                     SizedBox(height: 10.0.h),
                      CustomTextFormField(
                        controller: _pBrandController,
                        labelText: "Product Brand",
                        hintText: "Enter Product Brand",
                      ),
                       SizedBox(height: 10.0.h),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 05.w),
                              child: TextFormField(
                                controller: _pSizeController,
                                decoration: InputDecoration(
                                  labelText: 'Product Size',
                                  hintText:  "Upto which Size it can be wore",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 05.w),
                              child: TextFormField(
                                controller: _pTypeController,
                                decoration: InputDecoration(
                                  labelText: "Product Type",
                                  hintText: "Type of the Product",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0.h),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 05.w),
                              child: TextFormField(
                                controller: _pPriceController,
                                decoration: InputDecoration(
                                  labelText: 'Product Price',
                                  hintText:  "Price of the Prduct",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 05.w),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _pUsedController,
                                decoration: InputDecoration(
                                  labelText: "Product Used",
                                  hintText: "Used Times",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0.h),
                      CustomTextFormField(
                        maxline: 3,
                        controller: _pDescreptionController,
                        labelText: "Product Description",
                        hintText: "Enter Product Description",
                      ),
                      SizedBox(height: 10.0.h),
                      Row(
                        children: [
                          Checkbox(
                            value: _freeDelivery,
                            onChanged: (value) {
                              setState(() {
                                _freeDelivery = value ?? false;
                              });
                            },
                          ),
                          SizedBox(width:02.h),
                          const Text('Free Delivery', style: TextStyle(fontSize: 20),),
                          if (_freeDelivery)
                            TextButton(onPressed: () {},
                            child: const Text('Pay RS 1000/- ', style: TextStyle(color: Colors.red, fontSize: 20),)),
                        ],
                      ),
                      SizedBox(height: 5.0.h),
                      SizedBox(
                        height: 50.h,
                        width: 250.w,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          child: const Text("Save"),
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
