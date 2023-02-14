// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Todo {
  Todo({required this.id, required this.name, required this.checked});
  final String name;
  bool checked;
  int id;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoList(title: 'Flutter Demo Home Page'),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});
  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];
  int id = 1;

  /// Met à jour l'état de l'item. (Selectionné ou pas selectionné)
  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo list'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
            deleteItem: _deleteTodoItem
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(),
          tooltip: 'Add Item',
          child: const Icon(Icons.add)),
    );
  }

  /// Ajoute un item à la liste
  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(id: id, name: name, checked: false));
      id++;
    });
    _textFieldController.clear();
  }


  /// Supprimer un item à la liste
  void _deleteTodoItem(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });
    _textFieldController.clear();
  }
  /// Display dialog when user click on add button
  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final onTodoChanged;
  final deleteItem;



  TodoItem({required this.todo, required this.onTodoChanged, required this.deleteItem})
      : super(key: ObjectKey(todo));

  ///Barre la ligne lorsque l'item est choisi
  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;
    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete), 
        onPressed: () { 
          deleteItem(todo);
         },),
      leading: CircleAvatar(
        child: Text("${todo.id}"),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}
