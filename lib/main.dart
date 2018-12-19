import 'dart:async';

import 'package:comrade_app/detail.dart';
import 'package:comrade_app/settings.dart';
import 'package:flutter/material.dart';

import 'package:comrade_app/json/user.dart';

Future<void> main() async {
    await Settings.init();
    runApp(MyApp());
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
    final _users = Settings.users;
    final Set<String> _favorites = Settings.favorites;
    final _biggerFont = const TextStyle(fontSize: 18.0);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: _buildSuggestions(),
            drawer: Drawer(
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                        DrawerHeader(
                            child: Text('Quick access'),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                            ),
                        ),
                        Divider(),
                        ListTile(
                            title: Text('Favorite users'),
                            onTap: () {
                                pushSaved();
                            },
                        ),
                    ],
                ),
            ),
        );
    }

    void pushSaved() {
        Navigator.of(context).push(
            new MaterialPageRoute<void>(
                builder: (BuildContext context) {
                    final Iterable<ListTile> tiles = _favorites.map(
                                (String username) {
                                    User user = Settings.userMap[username];
                            return new ListTile(
                                title: new Text(
                                    "${user.last_name} ${user.first_name}",
                                    style: _biggerFont,
                                ),
                            );
                        },
                    );
                    final List<Widget> divided = ListTile
                            .divideTiles(
                        context: context,
                        tiles: tiles,
                    ).toList();
                    return new Scaffold(
                        appBar: new AppBar(
                            title: const Text('Favorite users'),
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
        final bool alreadySaved = _favorites.contains(user.username);
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
                        _favorites.remove(user.username);
                    } else {
                        _favorites.add(user.username);
                    }
                    Settings.saveSettings();
                });
            },
        );
    }
}
