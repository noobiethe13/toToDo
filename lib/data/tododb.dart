import 'package:hive/hive.dart';

class tododatabase {
  List<List<dynamic>> todolist = [];
  final myBox = Hive.box('mybox');

  void createinitialdata() {
    todolist = [["Create Your First Task", false, DateTime.now(), DateTime.now()]];
  }

  void loaddata() {
    List<dynamic> data = myBox.get("todolist");
    if (data != null && data.isNotEmpty) {
      data.sort((a, b) => a[3].compareTo(b[3]));
      todolist = data.map((element) => element as List<dynamic>).toList();
    }
  }

  void addTask(String task, bool status) {
    DateTime creationDate = DateTime.now();
    todolist.add([task, status, creationDate]);
    updatedatabase();
  }

  void updatedatabase() {
    myBox.put("todolist", todolist);
  }
}