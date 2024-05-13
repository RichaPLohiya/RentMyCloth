import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clothsonrent/src/view/homescreen.dart';
import 'package:clothsonrent/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class PutOnRent extends StatefulWidget {
  const PutOnRent({Key? key});

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
  final TextEditingController _pTypeController = TextEditingController();
  bool _freeDelivery = false;
  List<XFile?> _images = List.filled(3, null);
  final picker = ImagePicker();
  String? _selectedSize;
  bool isLoading = false;

  final List<String> _sizes = [
    'XS','S','M','L','XL','XXL','3XL','Free size'
  ];

  Future<void> _getImageFromGallery(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _images[index] = pickedFile;
      }
    });
  }

  Future<void> _getImageFromCamera(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _images[index] = pickedFile;
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

  Future<List<String>> _uploadImagesToStorage() async {
    List<String> imageUrls = [];

    for (XFile?imageFile in _images) {
      if (imageFile != null) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child(DateTime.now().millisecondsSinceEpoch.toString());
        UploadTask uploadTask = ref.putFile(File(imageFile.path));
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    }

    return imageUrls;
  }

  Future<void> _saveProductToFirestore(List<String> imageUrls) async {
    try {
      final userId = _auth.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final userName = userDoc.get('userName');
      final productId = FirebaseFirestore.instance.collection('products').doc().id;
      await FirebaseFirestore.instance.collection('products').doc(productId).set({
        'productId': productId,
        'userId': userId,
        'userName': userName,
        'productName': _pNameController.text,
        'productBrand': _pBrandController.text,
        'productDescription': _pDescreptionController.text,
        'productUsed': int.tryParse(_pUsedController.text) ?? 0,
        'productPrice': double.tryParse(_pPriceController.text) ?? 0.0,
        'productType': _pTypeController.text,
        'productSize': _selectedSize,
        'freeDelivery': _freeDelivery,
        'images': imageUrls,
        'createdAt': Timestamp.now(),
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Product added successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle error
      print('Error saving product: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error adding product: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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
          title: const Text(
            "Upload",
            style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/image6.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.9),
                BlendMode.lighten,
              ),
            ),
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Stack(
              children: [
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
                              child: _images[0] == null
                                  ? const Icon(Icons.add)
                                  : Image.file(File(_images[0]!.path), fit: BoxFit.cover),
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
                              child: _images[1] == null
                                  ? const Icon(Icons.add)
                                  : Image.file(File(_images[1]!.path), fit: BoxFit.cover),
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
                              child: _images[2] == null
                                  ? const Icon(Icons.add)
                                  : Image.file(File(_images[2]!.path), fit: BoxFit.cover),
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
                              padding: EdgeInsets.symmetric(horizontal: 05.w),
                              child: DropdownButtonFormField<String>(
                                value: _selectedSize,
                                decoration: InputDecoration(
                                  labelText: 'Product Size',
                                  hintText: "Select Product Size",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: _sizes.map((size) {
                                  return DropdownMenuItem<String>(
                                    value: size,
                                    child: Text(size),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSize = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 05.w),
                              child: TextFormField(
                                controller: _pTypeController,
                                decoration: InputDecoration(
                                  labelText: "Product Type",
                                  hintText: "Type of the Product",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),),
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
                              padding: EdgeInsets.symmetric(horizontal: 05.w),
                              child: TextFormField(
                                controller: _pPriceController,
                                decoration: InputDecoration(
                                  labelText: 'Product Price',
                                  hintText: "Price of the Product",
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
                          SizedBox(width: 02.h),
                          const Text(
                            'Free Delivery',
                            style: TextStyle(fontSize: 20),
                          ),
                          if (_freeDelivery)
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Pay RS 1000/- ',
                                style: TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 5.0.h),
                      SizedBox(
                        height: 50.h,
                        width: 250.w,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            List<String> imageUrls = await _uploadImagesToStorage();
                            _saveProductToFirestore(imageUrls);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: isLoading ? CircularProgressIndicator() : const Text("Save"),
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


