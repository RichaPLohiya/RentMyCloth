import 'dart:async';
import 'package:clothsonrent/src/view/mycart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'booking_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _auth = FirebaseAuth.instance;
  int _currentPage = 0;
  final List<String> imageUrls = [
    'assets/images/dress1_1.jpg',
    'assets/images/dress1_2.jpg',
    'assets/images/dress1_3.jpg',
  ];
  late Timer _timer;
  String? selectedSize;
  double totalPricePerDay = 5000;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % imageUrls.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
          title: const Text(
            "Product Detail",
            style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            SizedBox(
              width: double.infinity.w,
              height: double.infinity.h,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = (_currentPage + 1) % imageUrls.length;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imageUrls[_currentPage]),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      height: 280.h,
                      width: 430.w,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 280,
              child: Container(
                width: 450.w,
                height: 60.h,
                child: Padding(
                  padding:  EdgeInsets.only(left: 180.w, bottom: 25.w),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 3.0.w),
                        child: Icon(
                          index == _currentPage
                              ? Icons.circle
                              : Icons.circle_outlined,
                          size: 12,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2.2 - 50.h,
              left: MediaQuery.of(context).size.width / 8.5 - 50.w,
              right: MediaQuery.of(context).size.width / 8.5 - 50.w,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                width: 500.w,
                height: 500.h,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                       Padding(
                        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 5.0.h),
                        child: const Row(
                          children: [
                            Text("Anarkali",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                       Padding(
                        padding: EdgeInsets.only(left: 8.0.w,),
                        child: const Row(
                          children: [
                            Text("Etsy",),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.w,right: 50.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("Size",style: TextStyle(fontSize: 18),),
                            SizedBox(width: 05.w,),
                            _buildCircle("S"),
                            _buildCircle("M"),
                            _buildCircle("L"),
                            _buildCircle("XL"),
                            _buildCircle("XXL"),
                          ],
                        ),
                      ),
                      SizedBox(height:05.h ,),
                      Padding(
                        padding:  EdgeInsets.only(left: 8.0.w, top: 2.0.h),
                        child: Row(
                          children: [
                            const Text("Used: 3-4 times",),
                            SizedBox(width: 130.w),
                            const Text("Type:Sttiched"),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.h,),
                       Padding(
                        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                        child: const Text(
                          "Fleur Georgette Dress is the ideal choice.This dress features a stunning flair with a Turquoise Dupatta, intricate beadwork on the yoke, With exquisite handwork and Gotta patti\n"
                              "Length: 54 inches \n"
                              "Color: purple & turquoise blue \n"
                              "Sleeve Style: Full sleeves\n"
                              "Materials: Georgette, Gotapatti\n",
                          style: TextStyle(color: Colors.grey,),softWrap: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.w),
                        child: Row(
                          children: [
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Price (per day )",style: TextStyle(fontSize: 10),),
                                Text("RS.5,000/-",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 50.h,
                              width: 200.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  ShowBookingDialog.show(context,totalPricePerDay); // Pass total price per day here
                                },
                                child: const Text("Book Dates"),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(width:1.w,color: Colors.grey),
          shape: BoxShape.circle,
          color: selectedSize == size ? Colors.deepPurple : Colors.white70,
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: selectedSize == size ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
