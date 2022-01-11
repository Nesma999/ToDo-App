import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list_with_null_safety/Components/components.dart';
import 'package:to_do_list_with_null_safety/Components/constant.dart';
import 'package:to_do_list_with_null_safety/modules/archived.dart';
import 'package:to_do_list_with_null_safety/modules/done.dart';
import 'package:to_do_list_with_null_safety/modules/tasks.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeBNB extends StatelessWidget {
  @override
  TextEditingController task = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // bool isShow=false;
    // var icon=Icons.edit;
    List screens = [
      const TasksPage(),
      const DonePage(),
      const ArchivedPage(),
    ];
    List appBar = ['New Tasks', 'New Done', 'New Archived'];
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) =>
          BottomNavigationCubit()..createDatabase(), //create bloc
      child: BlocConsumer<BottomNavigationCubit, AppStates>(
        listener: (context, state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);//3shan 3yza ll bottom sheet t2fl b3d ma a3ml insert
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title:
                  Text(appBar[BottomNavigationCubit.get(context).currentIndex]),
            ),
            body: state is AppGetDatabaseLoadingState ? const Center(child: CircularProgressIndicator()) : screens[BottomNavigationCubit.get(context).currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: BottomNavigationCubit.get(context).currentIndex,
              onTap: (index) {
                BottomNavigationCubit.get(context).changBottomNavigation(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.title),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (BottomNavigationCubit.get(context).isShow) {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    BottomNavigationCubit.get(context)
                        .insertToDatabase(
                            title: task.text, date: date.text, time: time.text);
                    BottomNavigationCubit.get(context).changeBottomSheet(
                        bottomSheetIsShow: false, fabIcon: Icons.edit);
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) {
                          return Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextField(
                                    control: task,
                                    keyboard: TextInputType.text,
                                    text: 'Task Title',
                                    prefix: Icons.title,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Field is required';
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  defaultTextField(
                                      read: true,
                                      cursor: false,
                                      control: time,
                                      keyboard: TextInputType.datetime,
                                      text: 'Task Time',
                                      prefix: Icons.watch_later_outlined,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Field is required';
                                        }
                                      },
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          time.text =
                                              value!.format(context).toString();
                                        }).catchError((error) {
                                          print('${error.toString()}');
                                        });
                                      }),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  defaultTextField(
                                      read: true,
                                      cursor: false,
                                      control: date,
                                      keyboard: TextInputType.datetime,
                                      text: 'Task Date',
                                      prefix: Icons.calendar_today_outlined,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Field is required';
                                        }
                                      },
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2022-04-20'),
                                        ).then((value) {
                                          date.text =
                                              DateFormat.yMMMd().format(value!);
                                        }).catchError((error) {
                                          print('${error.toString()}');
                                        });
                                      })
                                ],
                              ),
                            ),
                          );
                        },
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    BottomNavigationCubit.get(context).changeBottomSheet(
                        bottomSheetIsShow: false, fabIcon: Icons.edit);
                      });
                  BottomNavigationCubit.get(context).changeBottomSheet(
                    bottomSheetIsShow: true,
                    fabIcon: Icons.add,
                  );
                }
              },
              child: Icon(BottomNavigationCubit.get(context).icon),
            ),
          );
        },
      ),
    );
  }
}
