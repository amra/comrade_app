import 'dart:async';
import 'dart:convert' as JSON;

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    List<User> users = new List<User>();
    final _suggestions = <WordPair>[];
    final _biggerFont = const TextStyle(fontSize: 18.0);

    @override
    Widget build(BuildContext context) {
        if (users.length == 0) {
            loadData().then((result) {
                users = new List.from(users)
                    ..addAll(result);
                _suggestions.clear();
                users.forEach((user) => _suggestions.add(new WordPair(user.last_name, user.first_name)));
                print("\n\n\nDONE\n\n\n");
                print("users: " + users.length.toString());
            });
        }

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

Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
}

Future<List<User>> loadData() async {
    try {
        String contents = await getFileData('data/data.json');

        final json = JSON.json.decode(contents);
        Data data = Data.fromJson(json);
//    print("data: "+data.colleges.length.toString());
        print("data: " + data.colleges.length.toString());

        return data.colleges;
    } catch (e) {
        print(e);
        return new List();
    }
}
