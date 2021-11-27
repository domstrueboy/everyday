import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streak',
      home: MyHomePage(title: 'Days in a row'),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //Loading counter value on start
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      int startTimestamp = prefs.getInt('start') ?? 0;
      if (startTimestamp > 0)
        _start = DateTime.fromMillisecondsSinceEpoch(startTimestamp);

      int endTimestamp = prefs.getInt('end') ?? 0;
      if (endTimestamp > 0)
        _end = DateTime.fromMillisecondsSinceEpoch(endTimestamp);
    });

    if (_end.difference(DateTime.now()).inDays > 1) {
      _start = DateTime.now();
      prefs.setInt('start', _start.millisecondsSinceEpoch);
      _end = DateTime.now();
      prefs.setInt('end', _start.millisecondsSinceEpoch);
    }
  }

  //Incrementing counter after click
  void _setLastDate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('end', _end.millisecondsSinceEpoch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Start $_start'),
            Text('End $_end'),
            Text(
              '${_end.difference(_start)}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setLastDate,
        tooltip: 'Next day',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
