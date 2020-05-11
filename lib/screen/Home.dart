import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:zikr_app/model/Dhikr.dart';
import 'package:zikr_app/screen/CounterList.dart';
import 'package:zikr_app/widgets/Counter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int counter;
  TextEditingController _textFieldController1 = TextEditingController();
  double percentage = 0.0;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;
  bool shouldVibrate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      int counter2 = ModalRoute.of(context).settings.arguments;
      if (counter2 != null) {
        setState(() {
          percentage = 0.0;
          counter = counter2;
        });
      } else {
        setState(() {
          percentage = 0.0;
          counter = 0;
        });
      }
    });

    percentageAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            setState(() {
              percentage = lerpDouble(percentage, newPercentage,
                  percentageAnimationController.value);
            });
          });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add to list"),
          content: SingleChildScrollView(
            child: TextField(
              controller: _textFieldController1,
              decoration: InputDecoration(labelText: "Please specify a name"),
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  "CANCEL",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text(
                  "SAVE",
                ),
                onPressed: () {
                  String title = _textFieldController1.text;
                  var date = DateTime.now();
                  print(title);
                  Provider.of<ListOfDhikr>(context).addDhikr(
                    title: title,
                    time: DateFormat("H:m").format(date).toString(),
                    date: DateFormat("dd/MM/yyyy").format(date).toString(),
                    count: counter,
                  );
                  Fluttertoast.showToast(
                      msg: 'Dhikr Added to list', gravity: ToastGravity.TOP);
                  setState(() {
                    _textFieldController1.text = "";
                  });
                }),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _textFieldController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ClipRRect(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.refresh),
                      iconSize: 35,
                      onPressed: () {
                        setState(() {
                          counter = 0;
                          percentage = 0;
                          newPercentage = 0;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 35,
                      onPressed: _showDialog,
                    ),
                    IconButton(
                      icon: Icon(Icons.vibration),
                      iconSize: 35,
                      onPressed: () {
                        setState(() {
                          shouldVibrate = !shouldVibrate;
                        });
                      },
                    ),
                    Spacer(),
                    // IconButton(
                    //   icon: Icon(Icons.more_vert),
                    //   iconSize: 35,
                    //   onPressed: () {},
                    // ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (counter > 0) {
                                counter--;
                                percentage = newPercentage;
                                if (newPercentage < -100) {
                                  newPercentage = 0;
                                  percentage = 0;
                                }
                                newPercentage -= 10;
                                percentageAnimationController.forward(
                                    from: 0.0);
                              }
                            });
                          },
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.yellow,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    foregroundPainter: CounterPainter(
                        lineColor: Colors.amber,
                        completeColor: Colors.blueAccent,
                        completePercent: percentage,
                        width: 8.0),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (shouldVibrate) Vibration.vibrate(duration: 500);
                            counter++;
                            percentage = newPercentage;
                            newPercentage += 10;
                            if (newPercentage > 100.0) {
                              percentage = 0.0;
                              newPercentage = 0.0;
                            }
                            percentageAnimationController.forward(from: 0.0);
                          });
                        },
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.height / 1.7,
                            height: MediaQuery.of(context).size.height / 1.7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: Center(
                              child: Container(
                                height: 150,
                                width: 150,
                                child: FittedBox(
                                  child: Text(
                                    "$counter",
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontFamily: "digital",
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: FlatButton(
                        color: Colors.green,
                        child: Text("save"),
                        onPressed: _showDialog,
                      ),
                    ),
                    Spacer(),
                    FlatButton(
                      color: Colors.green,
                      child: Text("saved List"),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CounterList.routeName);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
