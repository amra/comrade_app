import 'package:flutter/material.dart';

import 'package:comrade_app/json/user.dart';

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
                            child: Text('Usename: ${user.username}',),
                        ),
                        Divider(height: 8.0,),
                        SizedBox(
                            width: double.infinity,
                            child: Text('Email: ${user.email}'),
                        ),
                        Divider(height: 8.0,),
                        SizedBox(
                            width: double.infinity,
                            child: Text('Phone: ${user.phone}'),
                        ),
                        Divider(height: 8.0,),
                        SizedBox(
                            width: double.infinity,
                            child: Text('Company: ${user.company}'),
                        ),
                        Divider(height: 8.0,),
                        SizedBox(
                            width: double.infinity,
                            child: Text('Department: ${user.department}'),
                        ),
                        Divider(height: 8.0,),
                        SizedBox(
                            width: double.infinity,
                            child: Text('Location: ${user.location}'),
                        ),
                        Divider(height: 8.0,),
                        SizedBox(
                            width: double.infinity,
                            child: Text('Workforce id: ${user.workforce_id}'),
                        ),
                        Divider(height: 8.0,),
                        SizedBox(
                            width: double.infinity,
                            child: Text('Cost center: ${user.cost_center}'),
                        ),
                        Divider(),
                        Image.asset('assets/anonymous.png'),
                    ],
                ),
            ),
        );
    }
}
