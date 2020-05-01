import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zikr_app/model/Dhikr.dart';
import 'package:zikr_app/screen/CounterList.dart';
import 'package:zikr_app/screen/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ListOfDhikr(),
        ),
      ],
      child: MaterialApp(
        title: 'Zikr App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          CounterList.routeName: (context) => CounterList(),
        },
      ),
    );
  }
}
