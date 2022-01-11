import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_with_null_safety/layout/cubit/cubit.dart';

Widget defaultTextField({
  required TextEditingController control,
  required TextInputType keyboard,
  required String text,
  required IconData prefix,
  required String? Function(String? val) validate,
  Function? onTap,
  bool read = false,
  bool cursor = true,
}) {
  return TextFormField(
    readOnly: read,
    showCursor: cursor,
    controller: control,
    keyboardType: keyboard,
    decoration: InputDecoration(
      labelText: text,
      prefixIcon: Icon(prefix),
      border: const OutlineInputBorder(),
    ),
    validator: validate,
    onTap: () {
      onTap!();
    },
  );
}

// ll design bta3 ll task 3shan hetkrr fe ll done & arcive
// parameter map 3shan ast2bl feh ll data ll gaya
Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            IconButton(
              onPressed: () {
                BottomNavigationCubit.get(context)
                    .updateData(status: 'done', id: model['id']);
              },
              color: Colors.green,
              icon: const Icon(Icons.check_box),
            ),
            IconButton(
              onPressed: () {
                BottomNavigationCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);
              },
              color: Colors.blue,
              icon: const Icon(Icons.archive),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        BottomNavigationCubit.get(context)
            .deleteDataFromDatabase(id: model['id']);
      },
    );
