import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clothsonrent/src/view/notificationscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShowBookingDialog {
  static Future<void> show(BuildContext context, double totalPricePerDay, Map<String, dynamic> productData) async {
    final TextEditingController descriptionController = TextEditingController();
    DateTime? bookingDate;
    DateTime? returnDate;
    String differenceString = '0 days';
    double totalRent = 0;
    String? errorText;

    void updateDifference() {
      if (bookingDate != null && returnDate != null) {
        Duration difference = returnDate!.difference(bookingDate!);
        differenceString = '${difference.inDays} days';
        totalRent = difference.inDays * totalPricePerDay;
      }
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Booking',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          'Pickup Date:',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(width: 20.w),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                bookingDate = picked;
                                if (returnDate != null && returnDate!.isBefore(bookingDate!)) {
                                  returnDate = bookingDate;
                                }
                                updateDifference();
                                errorText = null;
                              });
                            }
                          },
                          child: Text(
                            bookingDate != null
                                ? '${bookingDate!.day}/${bookingDate!.month}/${bookingDate!.year}'
                                : 'Select Date',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          'Return Date:',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(width: 20.w),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: returnDate ?? DateTime.now(),
                              firstDate: bookingDate ?? DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                returnDate = picked;
                                updateDifference();
                                errorText = null;
                              });
                            }
                          },
                          child: Text(
                            returnDate != null
                                ? '${returnDate!.day}/${returnDate!.month}/${returnDate!.year}'
                                : 'Select Date',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          'Booked For:',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(width: 35.w),
                        Text(
                          differenceString,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Text(
                          'Total Rent:',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(width: 40.w),
                        Text(
                          'RS.${totalRent.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ],
                    ),
                    if (errorText != null)
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          errorText!,
                          style: TextStyle(fontSize: 14.sp, color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 20.h),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (bookingDate == null || returnDate == null) {
                      setState(() {
                        errorText = 'Please select the booking dates!!';
                      });
                      return;
                    }
                    if (returnDate!.isBefore(bookingDate!)) {
                      setState(() {
                        errorText = 'Return Date must be after Pickup Date.';
                      });
                      return;
                    }
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      String userId = user.uid;
                      String? userName = await _getUserName(userId);

                      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').doc(productData['productId']).get();
                      String ownerId = productSnapshot['userId'];
                      String ownerName = productSnapshot['userName'];

                      await FirebaseFirestore.instance.collection('order').add({
                        'productId': productData['productId'],
                        'size': productData['productSize'],
                        'bookDate': bookingDate,
                        'returnDate': returnDate,
                        'totalRent': totalRent,
                        'description': descriptionController.text,
                        'productName': productData['productName'],
                        'brand': productData['productBrand'],
                        'image': productData['images'],
                        'ownerId': ownerId,
                        'ownerName': ownerName,
                        'userId': userId,
                        'userName': userName,
                        'bookedFor': differenceString,
                        'createdAt': Timestamp.now(),
                      }).then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      }).catchError((error) {
                        print("Failed to add order: $error");
                        // Handle error here
                      });
                    }
                  },
                  child: Text(
                    'Send Request',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Future<String?> _getUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userSnapshot.get('userName');
    } catch (error) {
      print("Error fetching user name: $error");
      return null;
    }
  }
}
