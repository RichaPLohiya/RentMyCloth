import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyRequestItem {
  final String productName;
  final String brand;
  final String price;
  final String days;
  final String imagePath;
  final String status;

  MyRequestItem({
    required this.productName,
    required this.brand,
    required this.price,
    required this.days,
    required this.imagePath,
    required this.status,
  });
}

List<MyRequestItem> myrequest = [
  MyRequestItem(
    productName: 'Anarkali',
    brand: "Etsy",
    price: 'RS 2000/-',
    days: '2 days',
    imagePath: 'assets/images/dress1_1.jpg',
    status: 'Pending',
  ),
  MyRequestItem(
    productName: 'Choli',
    brand: "Maharani",
    price: 'RS 7000/-',
    days: '5 days',
    imagePath: 'assets/images/dress4_1.jpg',
    status: 'Rejected',
  ),
  MyRequestItem(
    productName: 'Couple Outfit',
    brand: "Ananta",
    price: 'RS 9000/-',
    days: '3 days',
    imagePath: 'assets/images/dress8_1.jpg',
    status: 'Accepted',
  ),
];

class MyRequestScreen extends StatelessWidget {
  final List<MyRequestItem> myRequestList;

  const MyRequestScreen({Key? key, required this.myRequestList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: myRequestList.length,
      itemBuilder: (context, index) {
        final requestItem = myRequestList[index];
        Color statusColor;
        switch (requestItem.status) {
          case 'Pending':
            statusColor = Color(0xFFD7871C);
            break;
          case 'Accepted':
            statusColor = Colors.green;
            break;
          case 'Rejected':
            statusColor = Colors.red;
            break;
          default:
            statusColor = Colors.black; // Default color if status is not recognized
        }
        return Dismissible(
          key: UniqueKey(),
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
            myRequestList.removeAt(index);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${requestItem.productName} deleted'),
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
                        image: AssetImage(requestItem.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 80.w,
                    height: 80.h,
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requestItem.productName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(requestItem.brand),
                      Text('Booked For: ${requestItem.days}'),
                      Text('Price: ${requestItem.price} per day'),
                      Padding(
                        padding: const EdgeInsets.only(left: 180.0),
                        child: Text(
                          requestItem.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
  }
}
