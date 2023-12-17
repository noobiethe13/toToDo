import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class todotiles extends StatelessWidget {
  final String taskname;
  final bool taskstatus;
  void Function(bool?)? onChanged;
  void Function(BuildContext)? deleteFunction;

  todotiles({super.key, required this.taskname, required this.taskstatus, required this.onChanged, required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,)
          ],
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Checkbox(value: taskstatus, onChanged: onChanged),
                Text(taskname),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    );
  }
}
