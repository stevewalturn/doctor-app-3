import 'package:my_app/features/todo/models/todo_model.dart';
import 'package:my_app/features/todo/todo_repository.dart';
import 'package:stacked/stacked.dart';

class TodoService with ListenableServiceMixin {
  final TodoRepository _repository;
  List<TodoModel> _todos = [];

  TodoService(this._repository);

  List<TodoModel> get todos => _todos;

  Future<void> initialize() async {
    try {
      _todos = await _repository.loadTodos();
      notifyListeners();
    } catch (e) {
      throw 'Failed to load todos. Please try again later.';
    }
  }

  Future<void> addTodo(String title) async {
    try {
      final todo = TodoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await _repository.saveTodo(todo);
      _todos.add(todo);
      notifyListeners();
    } catch (e) {
      throw 'Failed to add todo. Please try again.';
    }
  }

  Future<void> toggleTodo(String id) async {
    try {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        final updatedTodo =
            _todos[index].copyWith(isCompleted: !_todos[index].isCompleted);
        await _repository.updateTodo(updatedTodo);
        _todos[index] = updatedTodo;
        notifyListeners();
      }
    } catch (e) {
      throw 'Failed to update todo. Please try again.';
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _repository.deleteTodo(id);
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } catch (e) {
      throw 'Failed to delete todo. Please try again.';
    }
  }

  void sortTodosByDate() {
    _todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }
}
