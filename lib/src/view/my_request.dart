import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clothsonrent/src/view/mycart.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({Key? key}) : super(key: key);

  @override
  _MyRequestScreenState createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<QuerySnapshot> _orderStream() {
    return _firestore
        .collection('order')
        .where('userId', isEqualTo: _userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _orderStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              child: Text("Looks like there haven't been any requests placed yet!"),
            );
          }

          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              final Map<String, dynamic>? data =
              document.data() as Map<String, dynamic>?;

              String? imageUrl;
              if (data?['image'] != null &&
                  (data!['image'] as List).isNotEmpty) {
                imageUrl = data['image'][0];
              }

              DateTime pickupDate = (data?['bookDate'] as Timestamp).toDate();
              DateTime returnDate = (data?['returnDate'] as Timestamp).toDate();

              Color statusColor;
              IconData statusIcon;
              switch (data?['status']) {
                case 'Pending':
                  statusIcon = Icons.pending_actions;
                  statusColor = Color(0xFFD7871C);
                  break;
                case 'Accepted':
                  statusColor = Colors.green;
                  statusIcon = Icons.shopping_cart;
                  break;
                case 'Rejected':
                  statusColor = Colors.red;
                  statusIcon = Icons.cancel;
                  break;
                default:
                  statusColor = Colors.black;
                  statusIcon = Icons.error_outline;
                  break;
              }

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
                  _firestore.collection('order').doc(document.id).delete();
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
                    child: Row(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data?['productName'] ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text('${data?['brand'] ?? ''}'),
                            Text('Total Days: ${data?['bookedFor'] ?? ''}'),
                            Text('Total Rent :${data?['totalRent'] ?? ''} '),
                            Text(
                                'Pickup Date: ${pickupDate.day}/${pickupDate.month}/${pickupDate.year}'),
                            Text(
                                'Return Date: ${returnDate.day}/${returnDate.month}/${returnDate.year}'),
                            Text('Owner Name: ${data?['ownerName'] ?? ''}'),


                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (data?['status'] == 'Accepted') {
                                      // print("$data");
                                      final productId = data?['productId'];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyCartScreen(productId: productId),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        statusIcon,
                                        color: statusColor,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        '${data?['status'] ?? 'Pending'}',
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ],
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
    );
  }
}
