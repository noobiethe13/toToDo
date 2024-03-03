import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:totodo/data/tododb.dart';
import 'package:totodo/utils/dialogbox.dart';
import 'package:totodo/utils/todo_tile.dart';

class homepage extends StatefulWidget {
  homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final myBox = Hive.box('mybox');
  tododatabase db = tododatabase();
  final _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    if (myBox.get("todolist") == null) {
      db.createinitialdata(); // Create initial data with default date
    } else {
      db.loaddata();
    }
    super.initState();
  }

  void checkboxchange(bool? value, int index) {
    setState(() {
      db.todolist[index][1] = value!;

      if (value) {
        final completedTask = db.todolist.removeAt(index);
        db.todolist.add(completedTask);
      } else {
        final uncheckedTask = db.todolist.removeAt(index);

        int insertionIndex = 0;
        while (insertionIndex < db.todolist.length &&
            db.todolist[insertionIndex][3].isBefore(uncheckedTask[3])) {
          insertionIndex++;
        }
        db.todolist.insert(insertionIndex, uncheckedTask);
      }
    });
    db.updatedatabase();
  }

  void savetask(String text, DateTime selectedDate) {
    setState(() {
      db.todolist.add([text, false, DateTime.now(), selectedDate]);
      _controller.clear();
      db.todolist.sort((a, b) => a[3].compareTo(b[3])); // Sort based on assigned date (index 3)
    });
    Navigator.of(context).pop();
    db.updatedatabase();
  }

  void showCalendar() {
    showDialog(
      context: context,
      builder: (context) => Material(
        child: TableCalendar(
          firstDay: DateTime(2023),
          lastDay: DateTime.now().add(Duration(days: 365)),
          focusedDay: _selectedDate,
          availableGestures: AvailableGestures.all,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => dialogbox(
                  controller: _controller,
                  onSave: () => savetask(_controller.text, _selectedDate),
                  onExit: () => Navigator.pop(context),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.todolist.removeAt(index);
    });
    db.updatedatabase();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Center(
          child: Text(
            'ToTODO',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Colors.yellow,
        shadowColor: Colors.black,
        elevation: 7.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCalendar,
        child: Icon(Icons.calendar_today),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: db.todolist.length,
        itemBuilder: (context, index) {
          String taskName = db.todolist[index].length > 0 ? db.todolist[index][0] : "";
          bool taskStatus = db.todolist[index].length > 1 ? db.todolist[index][1] : false;
          DateTime creationDate = db.todolist[index].length > 2 ? db.todolist[index][2] : DateTime.now();
          DateTime assignDate = db.todolist[index].length > 3 ? db.todolist[index][3] : DateTime.now();

          return todotiles(
            taskname: taskName,
            taskstatus: taskStatus,
            creationDate: creationDate,
            assignedDate: assignDate,
            onChanged: (value) => checkboxchange(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
