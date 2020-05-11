import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zikr_app/model/Dhikr.dart';
import 'package:zikr_app/widgets/progress.dart';

enum Goto { Continue, Remove }

class CounterList extends StatefulWidget {
  static const String routeName = "/aboutus";

  @override
  _CounterListState createState() => _CounterListState();
}

class _CounterListState extends State<CounterList> {
  final List<Dhikr> dhikr = ListOfDhikr.items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Dhikr"),
      ),
      body: FutureBuilder(
        future: Provider.of<ListOfDhikr>(context, listen: false)
            .fetchAndSetDhikrList(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? circularProgress()
                : Consumer<ListOfDhikr>(
                    builder: (context, ls, ch) => ListView.builder(
                      itemCount:ListOfDhikr.items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(dhikr[index].count.toString()),
                          ),
                          title: Text(dhikr[index].title),
                          subtitle: Row(
                            children: <Widget>[
                              Text(dhikr[index].date),
                              SizedBox(
                                width: 20,
                              ),
                              Text(dhikr[index].time),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            onSelected: (Goto selectedValue) {
                              if (selectedValue == Goto.Continue) {
                                Navigator.of(context).pushNamed('/',
                                    arguments: dhikr[index].count);
                              } else {
                                setState(() {
                                  ls.removeDhikr(dhikr[index].id);
                                });
                              }
                            },
                            icon: Icon(Icons.menu),
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                child: Text('Continue'),
                                value: Goto.Continue,
                              ),
                              PopupMenuItem(
                                child: Text('Remove'),
                                value: Goto.Remove,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
