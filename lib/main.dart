import 'dart:async';
import 'dart:convert' as JSON;

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'data.dart';
import 'user.dart';

Future<void> main() async {
    var list = await loadData();
    DataHolder.users = list;
    runApp(MyApp());
}

class DataHolder {
    static List<User> users;
}

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
    List<User> _users = DataHolder.users;
    final _suggestions = <WordPair>[];
    final _biggerFont = const TextStyle(fontSize: 18.0);

    @override
    Widget build(BuildContext context) {

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

                    final index = i ~/ 2;
                    if (index >= _suggestions.length) {
                        var toAdd = _users.getRange(index, index + 10).map((user) => new WordPair(user.last_name, user.first_name));
                        _suggestions.addAll(toAdd);
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

Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
}

Future<List<User>> loadData() async {
    try {
        String contents = await getFileData('data/data.json');

        final json = JSON.json.decode(contents);
        Data data = Data.fromJson(json);
        print("data: " + data.colleges.length.toString());

        return data.colleges;
    } catch (e) {
        print(e);
        return new List();
    }
}
