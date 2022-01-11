import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list_with_null_safety/Components/constant.dart';
import 'package:to_do_list_with_null_safety/layout/cubit/states.dart';

class BottomNavigationCubit extends Cubit<AppStates>{
  BottomNavigationCubit() : super(AppInitialState());

  static BottomNavigationCubit get(context) =>BlocProvider.of(context);

  int currentIndex =0;
  bool isShow=false;
  IconData icon=Icons.edit;
  Database? database;
  List<Map> Newtasks =[];
  List<Map> Donetasks =[];
  List<Map> Archivetasks =[];

  void changBottomNavigation (int index){
    currentIndex=index;
    emit(AppChangedState());
  }

  void createDatabase() {
     openDatabase(
      'toDooApp.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE Task (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created Successfully');
        }).catchError((error) {
          print('error when create table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database).then((value){
          Newtasks=[];
          Donetasks=[];
          Archivetasks=[];
          value.forEach((element) {
            if(element['status']=='NEW'){
              Newtasks.add(element);
            }else if(element['status']=='done'){
              Donetasks.add(element);
            }else{
              Archivetasks.add(element);
            }
          });
          emit(AppGetDatabaseState());
        });
        print('Database Opened');
      },
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState()); //3mlt emit ll state fe ll then 3shan ata2kd an ll create 5lst
     });
  }

  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    return await database?.transaction((txn) {
      return txn
          .rawInsert(
          'INSERT INTO Task(title, date, time, status) VALUES("$title", "$date", "$time", "NEW")')
          .then((value) {
        print('${value} Inserted Successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database).then((value){
          Newtasks=[];
          Donetasks=[];
          Archivetasks=[];
          value.forEach((element) {
            if(element['status']=='NEW'){
              Newtasks.add(element);
            }else if(element['status']=='done'){
              Donetasks.add(element);
            }else{
              Archivetasks.add(element);
            }
          });
          emit(AppGetDatabaseState());
        });
      }).catchError((error) {
        print('error when insert ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(database)async{
    emit(AppGetDatabaseLoadingState());
     return await database.rawQuery('SELECT * FROM Task');
  }

  void changeBottomSheet({
    required bool bottomSheetIsShow,
    required IconData fabIcon,
}){
    isShow=bottomSheetIsShow;
    icon=fabIcon;
    emit(ChangeBottomSheetState());
  }

  void updateData({
  required String status,
    required int id,
}){
    database!.rawUpdate('UPDATE Task SET status=? WHERE ID=?',['$status', id]).then((value){
      print('Updated Successfully');
      getDataFromDatabase(database).then((value){
        Newtasks=[];
        Donetasks=[];
        Archivetasks=[];
        value.forEach((element) {
          if(element['status']=='NEW'){
            Newtasks.add(element);
          }else if(element['status']=='done'){
            Donetasks.add(element);
          }else{
            Archivetasks.add(element);
          }
        });
        emit(AppGetDatabaseState());
      });
      emit(AppUpdateDatabaseState());
    }).catchError((error){
      print('When Update Found Error${error.toString()}');
    });
  }

  void deleteDataFromDatabase({
  required int id,
}){
    database!.rawDelete('DELETE FROM Task WHERE id = ?', [id]).then((value){
      print('Record Deleted Successfully');
      getDataFromDatabase(database).then((value){
        Newtasks=[];
        Donetasks=[];
        Archivetasks=[];
        value.forEach((element) {
          if(element['status']=='NEW'){
            Newtasks.add(element);
          }else if(element['status']=='done'){
            Donetasks.add(element);
          }else{
            Archivetasks.add(element);
          }
        });
        emit(AppGetDatabaseState());
      });
      emit(AppDeleteDatabaseState());
    }).catchError((erorr){
      print('Error Found When Delete ${erorr.toString()}');
    });
  }
}