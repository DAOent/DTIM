import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? smallMobile;

  const Responsive({Key? key, required this.mobile, this.tablet, required this.desktop, this.smallMobile})
      : super(key: key);

  // This isMobile, isTablet, isDesktop help us later
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1200 && MediaQuery.of(context).size.width >= 768;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 1200 then we consider it a desktop
    if (_size.width >= 1200) {
      return desktop!;
    }
    // If width it less then 1200 and more then 768 we consider it as tablet
    else if (_size.width >= 768 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else if (_size.width >= 376 && _size.width <= 768 && mobile != null) {
      return mobile!;
    } else {
      return smallMobile!;
    }
  }
}

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
  }
}