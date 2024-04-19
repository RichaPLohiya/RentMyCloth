import 'package:clothsonrent/src/view/mycart.dart';
import 'package:flutter/material.dart';
import 'package:clothsonrent/src/view/p_detail_screen.dart';
import 'package:clothsonrent/src/view/profile.dart';
import 'package:clothsonrent/src/widgets/bottomnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;


    List<Category> categories = generateDummyCategories();
    List<PopularItem> popularItems = generateDummyPopularItems();
    List<RecentItem> recentItems = generateDummyRecentItems();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/image1.jpg'),
              ),
            ),
          ),
          title: const Text(
            "Home",
            style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MyCartScreen()));
            } ,  icon: const Icon(Icons.shopping_cart_outlined,color: Colors.deepPurple,size: 30.0,),),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5,left: 10),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: "Search here...",
                                hintStyle: const TextStyle(color: Colors.grey),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: const Icon(Icons.search),
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 180),
                      child: Text(
                        "Category",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0),
                      child: Text(
                        "see all",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  height: screenSize.height * 0.12.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var category in categories)
                        buildCategoryCard(context, category),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 180.0),
                      child: Text(
                        "Popular Item",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "see all",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2.h),
                GridView.count(
                  crossAxisCount: isPortrait ? 2 : 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var item in popularItems)
                      buildPopularItemCard(context, item),
                  ],
                ),
                SizedBox(height: 10.h),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 180.0),
                      child: Text(
                        "Recent Added",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "see all",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8.h),
                GridView.count(
                  crossAxisCount: isPortrait ? 2 : 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var item in recentItems)
                      buildRecentItemCard(context, item),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(
          currentIndex: 0,
        ),
      ),
    );
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;

Widget buildCategoryCard(BuildContext context, Category category) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 2.0, left: 4.0, right: 4.0),
    child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(category.imagePath),
            ),
            Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        )),
  );
}

Widget buildPopularItemCard(BuildContext context, PopularItem item) {
  return Padding(
    padding: const EdgeInsets.only(left: 2.0,right: 2.0),
    child: Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(
                  builder: (context) => const ProductDetailScreen(),
                  ),
                );
              },
              child: Container (
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(item.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 150.h,
                    width: 160.w,
                ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 130),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white.withOpacity(0.5),
                  ),
                height: 43.h,
                width: 160.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    Text(item.price,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ],
    ),
  );
}


Widget buildRecentItemCard(BuildContext context, RecentItem item) {
  return Padding(
    padding: const EdgeInsets.only(left: 2.0,right: 2.0),
    child: Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(
                  builder: (context) => const ProductDetailScreen(),
                ),
                );
              },
              child: Container (
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 150.h,
                width: 160.w,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 130),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white.withOpacity(0.5),
                ),
                height: 45.h,
                width: 160.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(item.price,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ],
    ),
  );
}


// Dummy data models
class Category {
  final String name;
  final String imagePath;

  Category({required this.name, required this.imagePath});
}

class PopularItem {
  final String name;
  final String price;
  final String imagePath;

  PopularItem({required this.name, required this.imagePath,required this.price});
}

class RecentItem {
  final String name;
  final String price;
  final String imagePath;

  RecentItem({required this.name, required this.imagePath,required this.price});
}

List<Category> generateDummyCategories() {
  return [
    Category(name: 'Mens', imagePath: 'assets/images/dress9_1.jpg'),
    Category(name: 'Womens', imagePath: 'assets/images/girl1.jpg'),
    Category(name: 'Kids', imagePath: 'assets/images/kid1.jpg'),
    Category(name: 'Bride', imagePath: 'assets/images/dress5_1.jpg'),

  ];
}

List<PopularItem> generateDummyPopularItems() {
  return [
    PopularItem(name: 'Anarkali', imagePath: 'assets/images/dress1_1.jpg',price: "2000/-"),
    PopularItem(name: 'Purusham', imagePath: 'assets/images/dress2_1.jpg',price: "3000/-"),
    PopularItem(name: 'Kids Gown', imagePath: 'assets/images/dress3_2.jpg',price: "1500/-"),
    PopularItem(name: 'Choli', imagePath: 'assets/images/dress4_1.jpg',price: "7000/-"),
    PopularItem(name: 'Groom Wear', imagePath: 'assets/images/dress6_1.jpg',price: "5000/-"),
    PopularItem(name: 'Bridal Choli', imagePath: 'assets/images/dress5_1.jpg',price: "80000/-"),
    PopularItem(name: 'Couple outfit', imagePath: 'assets/images/dress8_1.jpg',price: "9000/-"),
    PopularItem(name: 'Mendhi Wear', imagePath: 'assets/images/dress7_1.jpg',price: "1800/-"),

  ];
}

List<RecentItem> generateDummyRecentItems() {
  return [
    RecentItem(name: 'Raaya', imagePath: 'assets/images/dress10.jpg',price: "4000/-"),
    RecentItem(name: 'Sunkissed', imagePath: 'assets/images/dress11.jpg',price: "5100/-"),
    RecentItem(name: 'Floral Dress', imagePath: 'assets/images/dress12.jpg',price: "2000/-"),
    RecentItem(name: 'Tuxedo suit', imagePath: 'assets/images/dress13.jpg',price: "7000/-"),
    RecentItem(name: 'Reception Gown', imagePath: 'assets/images/dress14.jpg',price: "20000/-"),
  ];
}