import 'package:flutter/widgets.dart';

int cacheDimension(BuildContext context, double logicalSize) {
  return (logicalSize * MediaQuery.devicePixelRatioOf(context)).round();
}
