import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WatchImage extends StatelessWidget {
  const WatchImage({
    super.key,
    this.width = 290,
    this.height = 290,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/smartwatch.png',
      width: width.w,
      height: height.h,
      fit: BoxFit.contain,
    );
  }
}