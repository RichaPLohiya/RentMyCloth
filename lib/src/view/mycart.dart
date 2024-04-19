import 'package:clothsonrent/src/widgets/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'notificationscreen.dart';


class MyCartScreen extends StatefulWidget {
  const MyCartScreen({Key? key}) : super(key: key);

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  List<CartItem> cartItems = [
    CartItem(
      productName: 'Anarkali',
      brndName: "Etsy",
      price: 'RS 2000/-',
      imagePath: 'assets/images/dress1_1.jpg',
    ),
    CartItem(
      productName: 'Choli',
      brndName: "Maharani",
      price: 'RS 7000/-',
      imagePath: 'assets/images/dress4_1.jpg',
    ),
    CartItem(
      productName: 'Couple Outfit',
      brndName: "Ananta",
      price: 'RS 9000/-',
      imagePath: 'assets/images/dress8_1.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: const Text("My Cart", style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return _buildCartItem(cartItems[index], index);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "PROMO CODE",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: TextButton(
                      onPressed: () {},
                      child: Text("APPLY", style: TextStyle(color: Colors.deepPurple),),),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Total (${cartItems.length} items): ",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Rs. ${calculateTotal()}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 50.h,
                      width: 330.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const NotificationScreen(),
                            ),
                          );
                        },
                        child: const Text("Send Request"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 1),
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem, int index) {
    return Dismissible(
      key: Key(cartItem.productName),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text(
                  'Are you sure you want to delete this item from the cart?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        setState(() {
          cartItems.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cartItem.productName} removed from the cart'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.w),
        child: Card(
          elevation: 5,
          color: Colors.white,
          shadowColor: Colors.deepPurple,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container (
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(cartItem.imagePath),
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
                      cartItem.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(cartItem.brndName),
                    Text('Price: ${cartItem.price}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String calculateTotal() {
    int total = 0;
    for (var item in cartItems) {
      // Remove commas and 'RS ' from the price string before parsing
      String cleanedPrice = item.price.replaceAll(RegExp(r'[^\d]'), '');
      total += int.parse(cleanedPrice);
    }
    return total.toString();
  }
}

  class CartItem {
  final String productName;
  final String brndName;
  final String price;
  final String imagePath;

  CartItem({
    required this.productName,
    required this.brndName,
    required this.price,
    required this.imagePath,
  });
}
