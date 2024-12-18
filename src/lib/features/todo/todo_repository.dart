import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/features/todo/models/todo_model.dart';

class TodoRepository {
  static const String _todosKey = 'todos';

  Future<List<TodoModel>> loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosString = prefs.getString(_todosKey);

      if (todosString == null) return [];

      final todosList = jsonDecode(todosString) as List;
      return todosList
          .map((todo) => TodoModel.fromJson(todo as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Error loading todos from storage';
    }
  }

  Future<void> saveTodo(TodoModel todo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todos = await loadTodos();
      todos.add(todo);
      await prefs.setString(
          _todosKey, jsonEncode(todos.map((e) => e.toJson()).toList()));
    } catch (e) {
      throw 'Error saving todo to storage';
    }
  }

  Future<void> updateTodo(TodoModel updatedTodo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todos = await loadTodos();
      final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
      if (index != -1) {
        todos[index] = updatedTodo;
        await prefs.setString(
            _todosKey, jsonEncode(todos.map((e) => e.toJson()).toList()));
      }
    } catch (e) {
      throw 'Error updating todo in storage';
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todos = await loadTodos();
      todos.removeWhere((todo) => todo.id == id);
      await prefs.setString(
          _todosKey, jsonEncode(todos.map((e) => e.toJson()).toList()));
    } catch (e) {
      throw 'Error deleting todo from storage';
    }
  }
}
