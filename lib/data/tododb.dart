import 'package:hive/hive.dart';

class tododatabase{
  List todolist = [];
  final myBox = Hive.box('mybox');

  void createinitialdata(){
    todolist = [["Create Your First Task", false]];
  }

  void loaddata(){
    todolist = myBox.get("todolist");
  }

  void updatedatabase(){
    myBox.put("todolist", todolist);
  }
}