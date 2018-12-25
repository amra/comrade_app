import 'dart:async';

import 'package:comrade_app/detail.dart';
import 'package:comrade_app/json/user.dart';
import 'package:comrade_app/storage.dart';
import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

Future<void> main() async {
    await Storage.init(await PathStorage.create());
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
    final _users = Storage.users;
    final Set<String> _favorites = Storage.favorites;
    final _biggerFont = const TextStyle(fontSize: 18.0);
    final ScrollController controller = ScrollController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: _buildUsers(),
            drawer: Drawer(
                child: ListView(
                    controller: controller,
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
                                _favoriteUsers();
                            },
                        ),
                    ],
                ),
            ),
        );
    }

    void _favoriteUsers() {
        Navigator.of(context).push(
            new MaterialPageRoute<void>(
                builder: (BuildContext context) {
                    final Iterable<ListTile> tiles = _favorites.map(
                                (String username) {
                            User user = Storage.userMap[username];
                            return new ListTile(
                                title: new Text(
                                    "${user.last_name} ${user.first_name}",
                                    style: _biggerFont,
                                ),
                                onTap: _toDetailScreen(user),
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

    Function _toDetailScreen(User user) {
        return () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(user: user),
                ),
            );
        };
    }

    Widget _buildUsers() {
        return DraggableScrollbar.semicircle(
                alwaysVisibleScrollThumb: true,
                labelTextBuilder: (offset) {
                    int numItems = _users.length - 1;
                    final int currentItem = controller.hasClients ? (controller.offset / controller.position.maxScrollExtent * numItems) .floor() : 0;
                    var text = _users[currentItem].last_name;
                    return Text(text.substring(0, text.length > 5 ? 5 : text.length));
                },
                labelConstraints: BoxConstraints.tightFor(width: 80.0, height: 30.0),
                controller: controller,
                child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    controller: controller,
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                        return _buildRow(_users[index]);
                    }),
        );
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
            onTap: _toDetailScreen(user),
            onLongPress: () {
                setState(() {
                    if (alreadySaved) {
                        _favorites.remove(user.username);
                    } else {
                        _favorites.add(user.username);
                    }
                    Storage.saveSettings();
                });
            },
        );
    }
}
