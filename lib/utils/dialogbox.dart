import 'package:flutter/material.dart';
import 'package:totodo/utils/mybuttons.dart';

class dialogbox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onExit;
  dialogbox({super.key, required this.controller, required this.onSave, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[700],
          content: Container(
        height: 200,
            width: 10000000000000000000,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add Your New Task"
                  ),
                ),
                Row(
                  children: [
                    Mybuttons(text: "Save", onPressed: onSave),
                    const SizedBox(width: 8.0),
                    Mybuttons(text: "Cancel", onPressed: onExit)
                  ],
                )
              ],
            ),
    ),
    );
  }
}
