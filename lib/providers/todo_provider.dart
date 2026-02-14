import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';
import '../models/group_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  List<Group> _groups = [];
  String? _selectedGroupId;

  List<Todo> get todos {
    if (_selectedGroupId == null) {
      return _todos;
    }
    return _todos.where((todo) => todo.groupId == _selectedGroupId).toList();
  }

  List<Group> get groups => _groups;
  String? get selectedGroupId => _selectedGroupId;

  TodoProvider() {
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Todos
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> todosJson = jsonDecode(todosString);
      _todos = todosJson.map((json) => Todo.fromMap(json)).toList();
    }

    // Load Groups
    final String? groupsString = prefs.getString('groups');
    if (groupsString != null) {
      final List<dynamic> groupsJson = jsonDecode(groupsString);
      _groups = groupsJson.map((json) => Group.fromMap(json)).toList();
    }

    notifyListeners();
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosString =
        jsonEncode(_todos.map((todo) => todo.toMap()).toList());
    await prefs.setString('todos', todosString);
  }

  Future<void> _saveGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final String groupsString =
        jsonEncode(_groups.map((group) => group.toMap()).toList());
    await prefs.setString('groups', groupsString);
  }

  void selectGroup(String? groupId) {
    _selectedGroupId = groupId;
    notifyListeners();
  }

  void addGroup(String name, IconData icon) {
    final newGroup = Group(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
    );
    _groups.add(newGroup);
    _saveGroups();
    notifyListeners();
  }

  void deleteGroup(String groupId) {
    // Optional: Delete todos in the group or move them to default?
    // For now, let's keep todos but remove the group link (or delete them).
    // Let's delete todos for simplicity for now as per plan implies structure change.
    _todos.removeWhere((todo) => todo.groupId == groupId);
    _groups.removeWhere((group) => group.id == groupId);

    if (_selectedGroupId == groupId) {
      _selectedGroupId = null;
    }

    _saveTodos();
    _saveGroups();
    notifyListeners();
  }

  void addTodo(String title) {
    final newTodo = Todo(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
      groupId: _selectedGroupId,
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
