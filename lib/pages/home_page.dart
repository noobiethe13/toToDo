import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  @override
  void initState() {
    if(myBox.get("todolist") == null){
      db.createinitialdata();
    }
    else{
      db.loaddata();
    }
    super.initState();
  }

  void checkboxchange(bool? value, int index){
    setState(() {
      db.todolist[index][1] = !db.todolist[index][1];
    });
    db.updatedatabase();
  }

  void savetask(){
    setState(() {
      db.todolist.add([_controller.text, false]);
      _controller.clear();
    });
        Navigator.of(context).pop();
        db.updatedatabase();
  }
  void createnewtask() {
    showDialog(context: context,
        builder: (context) {
          return dialogbox(controller: _controller,
            onSave: savetask,
            onExit: () => {Navigator.of(context).pop(),
              _controller.clear()}
          );
        },
    );
  }

  void deleteTask(int index){
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
        title: Center(child: Text('ToTODO')),
        backgroundColor: Colors.yellow,
        shadowColor: Colors.black,
        elevation: 7.0,
      ),
      floatingActionButton: FloatingActionButton(onPressed: createnewtask,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: db.todolist.length,
        itemBuilder: (context, index){
          return todotiles(taskname: db.todolist[index][0],
              taskstatus: db.todolist[index][1],
              onChanged: (value) => checkboxchange(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        }
      ),
    );
  }
}