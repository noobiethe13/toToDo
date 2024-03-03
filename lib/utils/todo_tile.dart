import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class todotiles extends StatelessWidget {
  final String taskname;
  final bool taskstatus;
  final DateTime creationDate;
  final DateTime assignedDate;
  void Function(bool?)? onChanged;
  void Function(BuildContext)? deleteFunction;

  todotiles({
    super.key,
    required this.taskname,
    required this.taskstatus,
    required this.creationDate,
    required this.onChanged,
    required this.deleteFunction,
    required this.assignedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
            )
          ],
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskname,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        decoration: taskstatus ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationThickness: 2,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Created On: ${_formattedDate(creationDate)}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        decoration: taskstatus ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationThickness: 2,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Task Assigned For: ${_formattedDate(assignedDate)}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        decoration: taskstatus ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationThickness: 2,
                      ),
                    ),
                  ],
                ),
                Checkbox(value: taskstatus, onChanged: onChanged),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.yellow[700],
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  String _formattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

