import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'mycart.dart';

class ShowBookingDialog {
  static Future<void> show(BuildContext context, double totalPricePerDay) async {
    final TextEditingController descriptionController = TextEditingController();
    DateTime bookingDate = DateTime.now();
    DateTime returnDate = DateTime.now();
    late String differenceString;
    double totalRent = 0;

    void updateDifference() {
      Duration difference = returnDate.difference(bookingDate);
      differenceString = '${difference.inDays} days';
      totalRent = difference.inDays * totalPricePerDay;
    }

    updateDifference();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Booking'),
              content: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: <Widget>[

                    Row(
                      children: [
                        Text('Booking Date:'),
                        SizedBox(width: 75.w,),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: bookingDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                bookingDate = picked;
                                updateDifference();
                              });
                            }
                          },
                          child: Text(
                            '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Return Date:'),
                        SizedBox(width: 75.w,),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: returnDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                returnDate = picked;
                                updateDifference();
                              });
                            }
                          },
                          child: Text(
                            '${returnDate.day}/${returnDate.month}/${returnDate.year}',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Booked For:'),
                        SizedBox(width: 75.w,),
                        Text(differenceString),
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    Row(
                      children: [
                        Text('Total Rent:'),
                        SizedBox(width: 80.w,),
                        Text(totalRent.toStringAsFixed(2)),
                      ],
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCartScreen(),
                      ),
                    );
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
