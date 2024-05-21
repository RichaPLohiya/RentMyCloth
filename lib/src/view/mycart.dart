import 'package:clothsonrent/src/widgets/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCartScreen extends StatefulWidget {
  final String? productId;

  const MyCartScreen({Key? key, this.productId}) : super(key: key);

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<QuerySnapshot> _orderStream() {
    return _firestore
        .collection('order')
        .where('userId', isEqualTo: _userId)
        .where('status', isEqualTo: 'Accepted')
        .where('productId', isEqualTo: '${widget.productId}')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: const Text(
            "My Cart",
            style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _orderStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('There is No Product in Cart'),
                    );
                  }

                  return ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot document =
                          snapshot.data!.docs[index];
                      final Map<String, dynamic>? data =
                          document.data() as Map<String, dynamic>?;

                      String? imageUrl;
                      if (data?['image'] != null &&
                          (data!['image'] as List).isNotEmpty) {
                        imageUrl = data['image'][0];
                      }
                      DateTime pickupDate =
                          (data?['bookDate'] as Timestamp).toDate();
                      DateTime returnDate =
                          (data?['returnDate'] as Timestamp).toDate();

                      double totalRent =
                          (data?['totalRent'] as num?)?.toDouble() ?? 0;

                      return Dismissible(
                        key: Key(document.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          _firestore
                              .collection('order')
                              .doc(document.id)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Item deleted'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          color: Colors.white,
                          shadowColor: Colors.deepPurple,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrl ?? ''),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width: 90.w,
                                      height: 120.h,
                                    ),
                                    SizedBox(width: 16.w),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data?['productName'] ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text('${data?['brand'] ?? ''}'),
                                        Text(
                                            'Total Days: ${data?['bookedFor'] ?? ''}'),
                                        Text(
                                            'Pickup Date: ${pickupDate.day}/${pickupDate.month}/${pickupDate.year}'),
                                        Text(
                                            'Return Date: ${returnDate.day}/${returnDate.month}/${returnDate.year}'),
                                        Text(
                                            'Owner Name: ${data?['ownerName'] ?? ''}'),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Total Rent : Rs. $totalRent',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                SizedBox(
                  height: 50.h,
                  width: 346.w,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to make payment screen
                    },
                    child: const Text("Make Payment"),
                  ),
                ),
              ]),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(
          currentIndex: 1,
        ),
      ),
    );
  }
}