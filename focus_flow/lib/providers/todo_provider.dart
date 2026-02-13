import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String title) {
    final newTodo = Todo(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
    );
    _todos.add(newTodo);
    notifyListeners();
  }

  void toggleStatus(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}
