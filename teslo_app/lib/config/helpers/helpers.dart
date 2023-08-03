import 'package:flutter/material.dart';

class Helpers {
  static void showSnackbar(BuildContext context, String errorMessage ) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage)
      )
    );
  }
}