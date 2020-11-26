import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './ui/formadd/form_add_screen.dart';
import './ui/home/home_screen.dart';
import 'dart:ui';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todoist Flutter',
      home: Scaffold(
        key: _scaffoldState,
        backgroundColor: Color(0XFFEFF3F6),
        appBar: AppBar(
          backgroundColor: Color(0XFFEFF3F6),
          elevation: 10,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            "Todoist Flutter",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                  _scaffoldState.currentContext,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return FormAddScreen();
                  }),
                );
                if (result != null) {
                  setState(() {});
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ),
        body: HomeScreen(),
      ),
    );
  }
}
