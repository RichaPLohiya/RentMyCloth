import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtherRequestItem {
  final String userName;
  final String productName;
  final String brand;
  final String totalprice;
  final String days;
  final String pikupDate;
  final String returnDate;
  final String imagePath;

  OtherRequestItem({
    required this.userName,
    required this.productName,
    required this.brand,
    required this.totalprice,
    required this.days,
    required this.pikupDate,
    required this.returnDate,
    required this.imagePath,
  });
}

List<OtherRequestItem> otherRequest = [
  OtherRequestItem(
    userName: 'Yash',
    productName: 'Purusham',
    brand: "Manyavar",
    totalprice: 'RS 3000/-',
    days: '3 days',
    pikupDate: '10/04/2024',
    returnDate: '13/04/2024',
    imagePath: 'assets/images/dress2_1.jpg',
  ),
  OtherRequestItem(
    userName: 'Neha',
    productName: 'Floral Dress',
    brand: "Fashionista",
    totalprice: 'RS 2000/-',
    days: '2 days',
    pikupDate: '03/04/2024',
    returnDate: '04/04/2024',
    imagePath: 'assets/images/dress12.jpg',
  ),
  OtherRequestItem(
    userName: 'Vidit',
    productName: 'Tuxedo Suit',
    brand: "Super Hit",
    totalprice: 'RS 7000/-',
    days: '8 days',
    pikupDate: '13/04/2024',
    returnDate: '20/04/2024',
    imagePath: 'assets/images/dress13.jpg',
  ),

];

class OtherRequestScreen extends StatelessWidget {
  final List<OtherRequestItem> otherRequestList;

  const OtherRequestScreen({Key? key, required this.otherRequestList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: otherRequestList.length,
      itemBuilder: (context, index) {
        final otherRequestItem = otherRequestList[index];
        return Card(
          elevation: 5,
          color: Colors.white,
          shadowColor: Colors.deepPurple,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Image.asset(
                  otherRequestItem.imagePath,
                  width: 80.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          otherRequestItem.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 110.w,
                        ),
                        Text(otherRequestItem.userName),
                      ],
                    ),
                    Text(otherRequestItem.brand),
                    Text('Booked For: ${otherRequestItem.days}'),
                    Text('Pickup date : ${otherRequestItem.pikupDate}'),
                    Text('Return Date: ${otherRequestItem.returnDate}'),
                    Text('Total Price: ${otherRequestItem.totalprice}'),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text('Decline',style: TextStyle(color: Colors.red)),
                        ),
                        SizedBox(width: 10.w,),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Accepted successfully'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text('Accept',style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
