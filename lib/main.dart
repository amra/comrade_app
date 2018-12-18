import 'dart:async';
import 'dart:convert' as JSON;

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
//    List<User> _users = DataHolder.users;
    final _users = DataHolder.users;
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
//                    if (index >= _suggestions.length) {
//                        var toAdd = _users.getRange(index, index + 10).map((user) => new WordPair(user.last_name, user.first_name));
//                        _suggestions.addAll(toAdd);
//                    }
                    return _buildRow(_users[index]);
                });
    }

    Widget _buildRow(User user) {
        return ListTile(
            title: Text(
                user.last_name + ' ' + user.first_name,
                style: _biggerFont,
            ),
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(user: user),
                    ),
                );
            },
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

        data.colleges.sort((user1, user2) {
            if (user1.last_name == user2.last_name) {
                return user1.first_name.compareTo(user2.first_name);
            }
            return user1.last_name.compareTo(user2.last_name);
        });
        return data.colleges;
    } catch (e) {
        print(e);
        return new List();
    }
}

class DetailScreen extends StatelessWidget {
    // Declare a field that holds the Todo
    final User user;

    // In the constructor, require a Todo
    DetailScreen({Key key, @required this.user}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        // Use the Todo to create our UI
        return Scaffold(
            appBar: AppBar(
                title: Text("${user.first_name} ${user.last_name}"),
            ),
            body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('usename: ${user.username}\nemail: ${user.email}'),
            ),
        );
    }
}
