import 'package:flutter/material.dart';

class Mybuttons extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  Mybuttons({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: onPressed,
    color: Colors.indigo,
    child: Text(text),);
  }
}
