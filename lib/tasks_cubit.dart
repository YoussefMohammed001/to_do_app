import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:to_do_app/tasks_states.dart';

class TasksCubit extends Cubit<TasksStates>{
  TasksCubit() : super(InitTasksState());
  late Database database;
  List<Map>? tasks = [];
  List<Map>? importantTasks = [];

  Future<void> createDataBase() async {
    database = await openDatabase("tasks",version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, task TEXT, done INTEGER, important INTEGER)');
          print('created');
        },onOpen: (database){

          print('opened');
        });
    getTasks();
    getImportant();


  }
  void insertTasks({required String task}) async {
    await database?.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Tasks(task, done, important) VALUES("$task",0,0)');
      print('inserted1: $id1');

    });
    getTasks();

  }

  void getImportant() async{
    importantTasks = await database.query('Tasks',
        columns: ['id', 'task','done','important'],
        where: 'important = ?',
        whereArgs: [1]);
print(importantTasks);
    emit(GetImportantTasksStates());

  }


  void getTasks() async{
    tasks = await database.rawQuery('SELECT * FROM Tasks');
    print(tasks);
  //  setState((){});
emit(GetTasksStates());

  }


  void updateTasks({required int important, required int id, required int done}){
    database.rawUpdate(

        'UPDATE Tasks SET  done = ?, important = ? WHERE id = ?', ['$done','$important', '$id']);
getTasks();
getImportant();
  }

  void deleteContact({required int id}) async{
    int? count = await database?.rawDelete('DELETE FROM Tasks WHERE id = ?', ['$id']);
    assert(count ==1);
    getTasks();
    getImportant();
  }



}