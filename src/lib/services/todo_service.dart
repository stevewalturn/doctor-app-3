import 'package:my_app/features/home/todo_repository.dart';
import 'package:my_app/models/todo.dart';
import 'package:stacked/stacked.dart';

class TodoService with ListenableServiceMixin {
  final TodoRepository _repository;

  TodoService({TodoRepository? repository})
      : _repository = repository ?? TodoRepository() {
    listenToReactiveValues([_todos]);
  }

  final ReactiveValue<List<Todo>> _todos = ReactiveValue<List<Todo>>([]);
  List<Todo> get todos => _todos.value;

  void loadTodos() {
    try {
      _todos.value = _repository.getTodos();
    } catch (e) {
      throw 'Failed to load todos. Please try again.';
    }
  }

  void addTodo(String title) {
    try {
      final todo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        createdAt: DateTime.now(),
      );
      _repository.addTodo(todo);
      loadTodos();
    } catch (e) {
      throw 'Failed to add todo. Please try again.';
    }
  }

  void toggleTodoCompletion(String id) {
    try {
      _repository.toggleTodoCompletion(id);
      loadTodos();
    } catch (e) {
      throw 'Failed to update todo status. Please try again.';
    }
  }

  void deleteTodo(String id) {
    try {
      _repository.deleteTodo(id);
      loadTodos();
    } catch (e) {
      throw 'Failed to delete todo. Please try again.';
    }
  }
}
