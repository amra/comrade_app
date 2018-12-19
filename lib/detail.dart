import 'package:flutter/material.dart';

import 'user.dart';

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
