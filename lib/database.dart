import 'package:hive_flutter/hive_flutter.dart';

class Database {
  List todolist = [];

  final mybox = Hive.box('mybox');

  void createInitialdata() {
    todolist = [
      ['Go for a walk', false, '2023-02-28'],
      ['Have breakfast', false, '2023-03-01'],
    ];
  }

  void loadData() {
    todolist = mybox.get('TODOLIST');
  }

  void updateData() {
    mybox.put('TODOLIST', todolist);
  }
}
