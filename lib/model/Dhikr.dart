import 'package:flutter/cupertino.dart';
import 'package:zikr_app/helpers/db_helpers.dart';

class Dhikr {
  String id;
  String title;
  String date;
  String time;
  int count;
  Dhikr({this.title, this.count, this.date, this.time, this.id});
}

class ListOfDhikr with ChangeNotifier {
  String table = 'dhikr_list';
  static List<Dhikr> items = [];

  addDhikr({String title, String date, String time, int count}) {
    String id = DateTime.now().toString();
    DBHelper.insert(table, {
      'title': title,
      'id': id,
      'date': date,
      'time': time,
      'count': count,
    });
    Dhikr d = Dhikr(count: count, date: date, time: time, title: title, id: id);
    items.add(d);
    notifyListeners();
  }

  Future<void> fetchAndSetDhikrList() async {
    final dataList = await DBHelper.getData(table);
    print(dataList);
    items = dataList
        .map((item) => Dhikr(
              id: item['id'],
              count: item['count'],
              date: item['date'],
              time: item['time'],
              title: item['title'],
            ))
        .toList();
    notifyListeners();
  }

  removeDhikr(String id) {
    items.removeWhere((item) => item.id == id);
    DBHelper.delete(table, id);
    notifyListeners();
  }
}
