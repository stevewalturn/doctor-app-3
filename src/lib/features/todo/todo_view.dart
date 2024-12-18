import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/features/todo/todo_viewmodel.dart';
import 'package:my_app/features/todo/widgets/todo_input.dart';
import 'package:my_app/features/todo/widgets/todo_item.dart';
import 'package:my_app/ui/common/ui_helpers.dart';

class TodoView extends StackedView<TodoViewModel> {
  const TodoView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, TodoViewModel model, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: model.sortTodosByDate,
          ),
        ],
      ),
      body: model.isBusy
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (model.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.shade100,
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        horizontalSpaceSmall,
                        Expanded(
                          child: Text(
                            model.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: model.clearError,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: model.todos.length,
                    itemBuilder: (context, index) {
                      final todo = model.todos[index];
                      return TodoItem(
                        todo: todo,
                        onToggle: model.toggleTodo,
                        onDelete: model.deleteTodo,
                      );
                    },
                  ),
                ),
                TodoInput(
                  controller: TextEditingController(),
                  onSubmit: () {
                    if (model.isBusy) return;
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      model.addTodo(text);
                      controller.clear();
                    }
                  },
                  isLoading: model.isBusy,
                ),
              ],
            ),
    );
  }

  @override
  TodoViewModel viewModelBuilder(BuildContext context) => TodoViewModel(
        locator<TodoService>(),
      );

  @override
  void onViewModelReady(TodoViewModel model) => model.initialize();
}
