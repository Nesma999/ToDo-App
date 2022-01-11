import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_with_null_safety/Components/components.dart';
import 'package:to_do_list_with_null_safety/Components/constant.dart';
import 'package:to_do_list_with_null_safety/layout/cubit/cubit.dart';
import 'package:to_do_list_with_null_safety/layout/cubit/states.dart';

class ArchivedPage extends StatelessWidget {
  const ArchivedPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavigationCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = BottomNavigationCubit.get(context).Archivetasks.length;
          return tasks > 0
              ? ListView.separated(
            itemBuilder: (context, index) {
              return buildTaskItem(
                  BottomNavigationCubit.get(context).Archivetasks[index],context);
            },
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                color: Colors.grey[300],
                height: 1.0,
                width: double.infinity,
              ),
            ),
            itemCount: BottomNavigationCubit.get(context).Archivetasks.length,
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 100,
                  color: Colors.grey[500],
                ),
                Text(
                  'No Tasks Yet,Please Add Some Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
