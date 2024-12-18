import 'package:stacked/stacked.dart';
import 'package:my_app/app/services/todo_service.dart';
import 'package:my_app/features/todo/models/todo_model.dart';

class TodoViewModel extends BaseViewModel {
  final TodoService _todoService;
  String? _errorMessage;

  TodoViewModel(this._todoService);

  List<TodoModel> get todos => _todoService.todos;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    setBusy(true);
    try {
      await _todoService.initialize();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setBusy(false);
    }
  }

  Future<void> addTodo(String title) async {
    if (title.isEmpty) {
      _errorMessage = 'Todo title cannot be empty';
      notifyListeners();
      return;
    }

    setBusy(true);
    try {
      await _todoService.addTodo(title);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setBusy(false);
    }
  }

  Future<void> toggleTodo(String id) async {
    setBusy(true);
    try {
      await _todoService.toggleTodo(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setBusy(false);
    }
  }

  Future<void> deleteTodo(String id) async {
    setBusy(true);
    try {
      await _todoService.deleteTodo(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setBusy(false);
    }
  }

  void sortTodosByDate() {
    _todoService.sortTodosByDate();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
