import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_with_null_safety/shared/bloc_observe.dart';

import 'layout/cubit/cubit.dart';
import 'layout/homeBNB.dart';

void main() {
  BlocOverrides.runZoned(
        () {
      // Use blocs...
          runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeBNB(),
    );
  }
}

