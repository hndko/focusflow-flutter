import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> todosJson = jsonDecode(todosString);
      _todos = todosJson.map((json) => Todo.fromMap(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosString =
        jsonEncode(_todos.map((todo) => todo.toMap()).toList());
    await prefs.setString('todos', todosString);
  }

  void addTodo(String title) {
    final newTodo = Todo(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
    );
    _todos.add(newTodo);
    _saveTodos();
    notifyListeners();
  }

  void toggleStatus(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      _saveTodos();
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    _saveTodos();
    notifyListeners();
  }
}
