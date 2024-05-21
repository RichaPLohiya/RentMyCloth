import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'booking_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductDetailScreen({Key? key, required this.productData})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late int _currentPage;
  late Timer _timer;
  late PageController _pageController;
  late String selectedSize;

  final List<String> allSizes = ['XS', 'S', 'M', 'L', 'XL', '2XL', 'FS'];

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    selectedSize = '';
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 1.0);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentPage = ((_currentPage + 1) % (widget.productData['images'].length + 1)).toInt();
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = List<String>.from(widget.productData['images']);
    final String productName = widget.productData['productName'] ?? '';
    final double productPrice = widget.productData['productPrice'] ?? 0.0;
    final String productDescription = widget.productData['productDescription'] ?? '';
    final String productBrand = widget.productData['productBrand']?.toString() ?? '';
    final String maxEnabledSize = widget.productData['productSize']?.toString() ?? '';
    final String productUsed = widget.productData['productUsed']?.toString() ?? '';
    final String productType = widget.productData['productType']?.toString() ?? '';
    int maxEnabledIndex = allSizes.indexOf(maxEnabledSize);

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
              child: SizedBox(
                height: 280.h,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imageUrls.length + 1,
                  itemBuilder: (context, index) {
                    if (index == imageUrls.length) {
                      return Image.network(
                        imageUrls[0],
                        fit: BoxFit.fill,
                      );
                    } else {
                      return Image.network(
                        imageUrls[index],
                        fit: BoxFit.fill,
                      );
                    }
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              top: 280,
              child: Container(
                width: 450.w,
                height: 60.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 180.w, bottom: 25.w),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                        child: Icon(
                          index == _currentPage % imageUrls.length
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
                  padding: const EdgeInsets.only(top: 10.0, left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.0.h),
                        child: Text(
                          productName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Text(
                          productBrand,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Text("Type: $productType"),
                          ),
                          SizedBox(width:80.w),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Text("Used: $productUsed times"),
                          ),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 4.0.h),
                        child: SizedBox(
                          height: 50.0.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: allSizes.length,
                            itemBuilder: (context, index) {
                              final size = allSizes[index];
                              final bool isDisabled = index > maxEnabledIndex;
                              return GestureDetector(
                                onTap: isDisabled
                                    ? null
                                    : () {
                                  setState(() {
                                    selectedSize = size;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal:2.0),
                                  child: Container(
                                    width: 40.0.h,
                                    height: 40.0.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectedSize == size
                                          ? Colors.deepPurpleAccent
                                          : isDisabled
                                          ? Colors.grey
                                          : Colors.grey.withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        size,
                                        style: TextStyle(
                                          color: selectedSize == size
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0.h),
                        child: Text(
                          productDescription,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 6.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Price (per day)",
                              style: TextStyle(fontSize: 10),
                            ),
                            Text(
                              "RS.${productPrice.toStringAsFixed(2)}/-",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 50.h,
                          width: 200.w,
                          child: ElevatedButton(
                            onPressed: () {
                              ShowBookingDialog.show(
                                  context, productPrice, widget.productData);
                            },
                            child: const Text("Book Dates"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
