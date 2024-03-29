import 'package:dego_admin/widgets/text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.endPadding,
    this.isNeedHint = true,
    this.isPadding = true,
    this.suffix,
    this.readOnly = false,
    this.textInputType,
    this.validator,
    this.prefix,
    this.hintColor,

    this.text,
    this.isRegister,
    this.isSearch,
    this.text2,
    this.textColor,
    this.obscure=false,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final String? text;
  final String? text2;
  final double? endPadding;
  final bool? isNeedHint;
  final bool? isPadding;
  final bool? isRegister;
  final bool? isSearch;
  final bool obscure;
  final Widget? suffix;
  final Widget? prefix;
  final bool? readOnly;
  final Color? hintColor;
  final Color? textColor;
  final TextInputType? textInputType;
  final FormFieldValidator? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: text!,
                  txtSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black),
              CustomText(
                  text: text2 ?? '',
                  txtSize: 12.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ],
          ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 70.h,
          width: double.infinity,
          child: TextFormField(
            textDirection: TextDirection.ltr,
            maxLines: 5,
            textAlign: TextAlign.start,
            validator: validator,
            readOnly: readOnly!,
            controller: controller,
            keyboardType: textInputType,
            obscureText: obscure,
            style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.black),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20.w,top: 20.h),
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: hintColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w100,
                  ),
              focusedBorder: isRegister == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ))
                  : isSearch == true
                      ? InputBorder.none
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.r),
                          borderSide: const BorderSide(
                              color: Colors.black, width: .1),
                        ),
              suffixIcon: suffix ?? const SizedBox(),
              prefixIcon: prefix,
              border: isRegister == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1))
                  : isSearch == true
                      ? InputBorder.none
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.r),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: .1,
                          ),
                        ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.r),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: .5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
