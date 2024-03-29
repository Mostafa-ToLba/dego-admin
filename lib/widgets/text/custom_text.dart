import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? txtSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final Function()? onTap;

  const CustomText(
      {super.key,
      required this.text,
      this.txtSize,
      this.fontWeight,
      this.color,
      this.textAlign = TextAlign.center,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        (text),
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: color,
              fontSize: txtSize,
              fontWeight: fontWeight ?? FontWeight.w400,
            ),
      ),
    );
  }
}
