import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtherRequestScreen extends StatefulWidget {
  const OtherRequestScreen({Key? key}) : super(key: key);

  @override
  _OtherRequestScreenState createState() => _OtherRequestScreenState();
}

class _OtherRequestScreenState extends State<OtherRequestScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<QuerySnapshot> _orderStream() {
    return _firestore
        .collection('order')
        .where('ownerId', isEqualTo: _userId)
        .snapshots();
  }

  void _updateStatus(String orderId, String newStatus) {
    _firestore.collection('order').doc(orderId).update({'status': newStatus});
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
              child: Text('No Request yet! Keep up the good work!'),
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

              DateTime pickupDate =
              (data?['bookDate'] as Timestamp).toDate();
              DateTime returnDate =
              (data?['returnDate'] as Timestamp).toDate();

              bool accepted = data?['status'] == 'Accepted';
              bool rejected = data?['status'] == 'Rejected';

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
                    child: Stack(
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    'Total Rent :${data?['totalRent'] ?? ''} '),
                                Text(
                                    'Pickup Date: ${pickupDate.day}/${pickupDate.month}/${pickupDate.year}'),
                                Text(
                                    'Return Date: ${returnDate.day}/${returnDate.month}/${returnDate.year}'),
                                Text('Customer Name: ${data?['userName'] ?? ''}'),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _updateStatus(document.id, 'Rejected');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('Request declined'),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Decline',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      ElevatedButton(
                                        onPressed: () {
                                          _updateStatus(document.id, 'Accepted');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                              Text('Request accepted'),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Accept',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (accepted)
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          )
                        else if (rejected)
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          )
                        else
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.yellow
                              ,
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
    );
  }
}
