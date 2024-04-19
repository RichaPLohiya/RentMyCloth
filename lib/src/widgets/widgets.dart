
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? iconData;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final int? maxline;
  final String? prefixText;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.iconData,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.maxline,
    this.prefixText,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(

        maxLines: maxline,
        controller: controller,
        initialValue: initialValue,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          prefixText: prefixText,
          labelText: labelText,
          hintText:hintText,
          suffixIcon: iconData != null ? Icon(iconData) : null,
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        ),
      ),
    );
  }
}
class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool loading;


  const CustomElevatedButton({
    Key? key,
    this.onPressed,
    required this.label,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      width: 390.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
        ),
        child: Center(
          child: loading? CircularProgressIndicator(strokeWidth: 3,):
          Text(label,),
        ),
      ),
    );
  }
}

