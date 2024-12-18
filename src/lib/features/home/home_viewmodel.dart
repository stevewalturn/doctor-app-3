import 'package:my_app/app/app.locator.dart';
import 'package:my_app/models/todo.dart';
import 'package:my_app/services/todo_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _todoService = locator<TodoService>();
  final _bottomSheetService = locator<BottomSheetService>();

  List<Todo> get todos => _todoService.todos;

  Future<void> loadTodos() async {
    try {
      await runBusyFuture(_todoService.loadTodos());
    } catch (e) {
      setError(e);
    }
  }

  Future<void> showAddTodoSheet() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: 'Add Todo',
      description: 'Enter todo details',
    );

    if (response?.confirmed == true && response?.data != null) {
      try {
        await runBusyFuture(
          Future(() => _todoService.addTodo(response!.data as String)),
        );
      } catch (e) {
        setError('Failed to add todo: ${e.toString()}');
      }
    }
  }

  Future<void> toggleTodoCompletion(String id) async {
    try {
      await runBusyFuture(Future(() => _todoService.toggleTodoCompletion(id)));
    } catch (e) {
      setError('Failed to update todo: ${e.toString()}');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await runBusyFuture(Future(() => _todoService.deleteTodo(id)));
    } catch (e) {
      setError('Failed to delete todo: ${e.toString()}');
    }
  }
}
