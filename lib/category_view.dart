import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/todo-item.dart';
import 'package:pocket_recipes/services/db.dart';

class CategoryView extends StatefulWidget {
  CategoryView({Key key, this.title, this.database}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final database;

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  String _task;

  List<TodoItem> _tasks = [];

  TextStyle _style = TextStyle(color: Colors.white, fontSize: 24);

  List<Widget> get _items => _tasks.map((item) => format(item)).toList();

  Widget format(TodoItem item) {

    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
          padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
          child: FlatButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(item.task, style: _style),
                  Icon(item.complete == true ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: Colors.white)
                ]
            ),
            onPressed: () => _toggle(item),
          )
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
  }

  void _toggle(TodoItem item) async {

    item.complete = !item.complete;
    dynamic result = await DB.update(TodoItem.table, item);
    print(result);
    refresh();
  }

  void _delete(TodoItem item) async {

    DB.delete(TodoItem.table, item);
    refresh();
  }

  void _save() async {

    Navigator.of(context).pop();
    TodoItem item = TodoItem(
        task: _task,
        complete: false
    );

    await DB.insert(TodoItem.table, item);
    setState(() => _task = '' );
    refresh();
  }

  void _create(BuildContext context) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Create New Task"),
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
              decoration: InputDecoration(labelText: 'Task Name', hintText: 'e.g. pick up bread'),
              onChanged: (value) { _task = value; },
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

    List<Map<String, dynamic>> _results = await DB.query(TodoItem.table);
    _tasks = _results.map((item) => TodoItem.fromMap(item)).toList();
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
          tooltip: 'New TODO',
          child: Icon(Icons.library_add),
        )
    );
  }
}