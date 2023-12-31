import 'package:flutter/material.dart';

Widget buildLoadingIndicator() {
  return const Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
}
