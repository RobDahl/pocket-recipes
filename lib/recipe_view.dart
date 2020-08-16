import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/recipe-item.dart';
import 'package:pocket_recipes/services/db.dart';

class RecipeView extends StatefulWidget {
  RecipeView({Key key, this.title, this.category}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String category;

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  String _title;

  List<RecipeItem> _categories = [];

  TextStyle _style = TextStyle(color: Colors.white, fontSize: 24);

  List<Widget> get _items => _categories.map((item) => format(item)).toList();

  Widget format(RecipeItem item) {

    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
          padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
          child: FlatButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(item.title, style: _style)
                ]
            ),
            onPressed: () => null,
          )
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
  }

//  void _toggle(CategoryItem item) async {
//
//    item.complete = !item.complete;
//    dynamic result = await DB.update(CategoryItem.table, item);
//    print(result);
//    refresh();
//  }

  void _delete(RecipeItem item) async {

    DB.delete(RecipeItem.table, item);
    refresh();
  }

  void _save() async {

    Navigator.of(context).pop();
    // Sets category based on currently viewed category
    RecipeItem item = RecipeItem(
        title: _title,
        category: widget.category,
    );

    await DB.insert(RecipeItem.table, item);
    setState(() => _title = '' );
    refresh();
  }

  void _create(BuildContext context) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Create New Recipe"),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop()
              ),
              FlatButton(
                  child: Text('Save'),
                  onPressed: () => _save()
              )
            ],
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: 'Recipe Name', hintText: 'e.g. Breakfast'),
              onChanged: (value) { _title = value; },
            ),
          );
        }
    );
  }

  @override
  void initState() {

    refresh();
    super.initState();
  }

  void refresh() async {

    List<Map<String, dynamic>> _results = await DB.queryCategory(RecipeItem.table, widget.category);
    _categories = _results.map((item) => RecipeItem.fromMap(item)).toList();
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar( title: Text(widget.title) ),
        body: Center(
            child: ListView( children: _items )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () { _create(context); },
          tooltip: 'New Recipe',
          child: Icon(Icons.library_add),
        )
    );
  }
}