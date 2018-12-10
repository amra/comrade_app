import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'data.dart';
import 'user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    final users = new List<User>();
    final _suggestions = <WordPair>[];
    final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    var data = loadData().then(data);
    users.add(data.);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return Divider();

          var data = loadData();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data/data.json');
}

Future<List<User>> loadData() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    Data data = json.decode(contents);
    return data.colleges;
  } catch (e) {
    return new List();
  }
}

//Future<int> fetchSavedItemNo() async { // you need to return a Future to the FutureBuilder
//    Future<Directory> dir = getApplicationDocumentsDirectory();
//    File jsonFile = new File(dir.path+ "/" + fileName);
//    bool fileExists = jsonFile.existsSync();
//
//    int itemNo;
//    // you should also not set state because the FutureBuilder will take care of that
//    if (fileExists)
//        itemNo = json.decode(jsonFile.readAsStringSync())['item'];
//
//    itemNo ??= 0; // this is a great null-aware operator, which assigns 0 if itemNo is null
//
//    return itemNo;
//}
//
//@override
//Widget build(BuildContext context) {
//    return FutureBuilder<int>(
//        future: fetchSavedItemNo(),
//        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
//            if (snapshot.connectionState == ConnectionState.done) {
//                print('itemNo in FutureBuilder: ${snapshot.data}';
//                        return Text('Hello');
//            } else
//                return Text('Loading...');
//        },
//    );
//}
