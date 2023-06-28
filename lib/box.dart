import 'package:flutter/material.dart';
import 'gshit.dart';

class MyCheckBoxList extends StatefulWidget {
  const MyCheckBoxList({Key? key}) : super(key: key);

  @override
  _MyCheckBoxListState createState() => _MyCheckBoxListState();
}

class _MyCheckBoxListState extends State<MyCheckBoxList> {
  List<int> itemCounts = List<int>.filled(GoogleSheetsApi.currentNotes.length, 0);

  void incrementItem(int index) {
    setState(() {
      itemCounts[index]++;
    });
  }

  void decrementItem(int index) {
    if (itemCounts[index] > 0) {
      setState(() {
        itemCounts[index]--;
      });
    }
  }

  void deleteItem(int index) {
    if (index >= 0 && index < GoogleSheetsApi.currentNotes.length) {
      setState(() {
        GoogleSheetsApi.currentNotes.removeAt(index);
        itemCounts.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: GoogleSheetsApi.currentNotes.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: GoogleSheetsApi.currentNotes[index][1] == 0
                  ? Colors.grey[200]
                  : Colors.grey[300],
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      GoogleSheetsApi.currentNotes[index][0],
                      style: TextStyle(
                        color: GoogleSheetsApi.currentNotes[index][1] == 0
                            ? Colors.grey[800]
                            : Colors.grey[500],
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => decrementItem(index),
                        ),
                        Text('${itemCounts[index]}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => incrementItem(index),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteItem(index),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Number extends StatefulWidget {
  const Number({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Number> createState() => _NumberState();
}

class _NumberState extends State<Number> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
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
          children: <Widget>[
            const Text("Jumlah Barang = "),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _decrementCounter,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _incrementCounter,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MyCheckBoxList(),
          ),
          Number(title: 'Number Counter'),
        ],
      ),
    ),
  ));
}