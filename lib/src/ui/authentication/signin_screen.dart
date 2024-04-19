// import 'package:animate_do/animate_do.dart';
// import 'package:clothsonrent/src/ui/authentication/login_screen.dart';
// import 'package:clothsonrent/src/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//
//
// class SigninScreen extends StatefulWidget {
//   const SigninScreen({super.key});
//
//   @override
//   State<SigninScreen> createState() => _SigninScreenState();
// }
//
// class _SigninScreenState extends State<SigninScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phonecontroller = TextEditingController();
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(30),
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset('assets/images/image1.jpg', fit: BoxFit.cover, width: 280.w,),
//                 SizedBox(height: 50.h),
//                 FadeInDown(child: Text('REGISTER',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.grey.shade900),),
//                 ),
//                 SizedBox(height: 20.h),
//                 FadeInDown(
//                   delay: Duration(milliseconds: 400),
//                   child: Stack(
//                     children: [
//                       CustomTextFormField(
//                         controller: _nameController,
//                         labelText: "Name",
//                         keyboardType: TextInputType.name,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your Name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 FadeInDown(
//                   delay: Duration(milliseconds: 400),
//                   child: Stack(
//                     children: [
//                       CustomTextFormField(
//                         controller: _phonecontroller,
//                         labelText: "Mobile Number",
//                         hintText: "+91 12345 67890",
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your Number';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 FadeInDown(
//                   delay: Duration(milliseconds: 600),
//                   child: SizedBox(
//                     height: 60,
//                     width: 390,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _isLoading = true;
//                         });
//                         Future.delayed(Duration(seconds: 2), () {
//                           setState(() {
//                             _isLoading = false;
//                           });
//                           //Navigator.push(context, MaterialPageRoute(builder: (context) => ()));
//                         });
//                       },
//                       child: _isLoading
//                           ? Container(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                               ),
//                             ): Text("Register",),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10,),
//                 FadeInDown(
//                   delay: Duration(milliseconds: 800),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Already have an account?",
//                         style: TextStyle(color: Colors.grey.shade700),
//                       ),
//                       TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => LoginScreen()));
//                           },
//                           child: const Text("Signup")),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }
