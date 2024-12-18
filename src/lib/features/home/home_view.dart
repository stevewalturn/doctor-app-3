import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/features/home/home_viewmodel.dart';
import 'package:my_app/features/home/widgets/todo_item.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.modelError.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: viewModel.loadTodos,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : viewModel.todos.isEmpty
                  ? const Center(
                      child: Text(
                          'No todos yet. Add one by tapping the + button!'),
                    )
                  : ListView.builder(
                      itemCount: viewModel.todos.length,
                      itemBuilder: (context, index) {
                        final todo = viewModel.todos[index];
                        return TodoItem(
                          todo: todo,
                          onToggle: viewModel.toggleTodoCompletion,
                          onDelete: viewModel.deleteTodo,
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.showAddTodoSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.loadTodos();
}
