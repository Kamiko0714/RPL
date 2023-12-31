import 'dart:async';

import 'package:flutter/material.dart';
import 'button.dart';
import 'box.dart';
import 'gshit.dart';
import 'loading.dart';
import 'grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  void _post() {
    GoogleSheetsApi.insert(_controller.text);
    _controller.clear();
    setState(() {});
  }

  // wait for the data to be fetched from google sheets
  void startLoading() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // start loading until the data arrives
    if (GoogleSheetsApi.loading == true) {
      startLoading();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'things to do..',
          style: TextStyle(color: Colors.grey[600]),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GoogleSheetsApi.loading == true
                  ? LoadingCircle()
                  : MyCheckBoxList(),
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'enter..',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                          },
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      text: 'P O S T',
                      function: _post,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
