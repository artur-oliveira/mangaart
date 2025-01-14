import 'package:flutter/material.dart';

class Progress {
  static Widget loading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [CircularProgressIndicator()],
      ),
    );
  }
}