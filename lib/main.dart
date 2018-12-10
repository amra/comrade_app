import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

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
