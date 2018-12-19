import 'dart:async';
import 'dart:convert' as JSON;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'data.dart';
import 'user.dart';

import 'package:path_provider/path_provider.dart';

Future<void> main() async {
    DataHolder.users = await loadData();
    DataHolder.localPath = await localPath();
    runApp(MyApp());
}

class DataHolder {
    static List<User> users;
    static String localPath;
}

Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
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
    final Set<User> _saved = new Set<User>();
    final _biggerFont = const TextStyle(fontSize: 18.0);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
                actions: <Widget>[
                    new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
                ],
            ),
            body: _buildSuggestions(),
            drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the Drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                        DrawerHeader(
                            child: Text('Drawer Header'),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                            ),
                        ),
                        ListTile(
                            title: Text('Item 1'),
                            onTap: () {
                                // Update the state of the app
                                // ...
                                // Then close the drawer
                                Navigator.pop(context);
                            },
                        ),
                        ListTile(
                            title: Text('Item 2'),
                            onTap: () {
                                // Update the state of the app
                                // ...
                                // Then close the drawer
                                Navigator.pop(context);
                            },
                        ),
                    ],
                ),
            ),
        );
    }

    void _pushSaved() {
        Navigator.of(context).push(
            new MaterialPageRoute<void>(
                builder: (BuildContext context) {
                    final Iterable<ListTile> tiles = _saved.map(
                                (User user) {
                            return new ListTile(
                                title: new Text(
                                    user.last_name + ' ' + user.first_name,
                                    style: _biggerFont,
                                ),
                            );
                        },
                    );
                    final List<Widget> divided = ListTile
                            .divideTiles(
                        context: context,
                        tiles: tiles,
                    )
                            .toList();

                    return new Scaffold(
                        appBar: new AppBar(
                            title: const Text('Saved Suggestions'),
                        ),
                        body: new ListView(children: divided),
                    );
                },
            ),
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
        final bool alreadySaved = _saved.contains(user);
        return ListTile(
            title: Text(
                user.last_name + ' ' + user.first_name,
                style: _biggerFont,
            ),
            trailing: new Icon(
                alreadySaved ? Icons.star : Icons.star_border,
                color: alreadySaved ? Colors.yellow : null,
            ),
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(user: user),
                    ),
                );
            },
            onLongPress: () {
                setState(() {
                    if (alreadySaved) {
                        _saved.remove(user);
                    } else {
                        _saved.add(user);
                    }
                });
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
    final User user;

    DetailScreen({Key key, @required this.user}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("${user.first_name} ${user.last_name}"),

            ),
            body: Padding(
                padding: EdgeInsets.only(left: 8.0, top: 12.0),
                child: Column(
                    children: <Widget>[
                        SizedBox(
                            width: double.infinity,
                            child: Text('usename: ${user.username}',),
                        ),
                        Divider(height: 8.0,),
                        SizedBox(
                            width: double.infinity,
                            child: Text('email: ${user.email}'),
                        ),
                        Divider(),
                        Image.asset('assets/anonymous.png'),
                    ],
                ),
            ),
        );
    }
}
