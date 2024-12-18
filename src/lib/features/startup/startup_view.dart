import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/features/startup/startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({super.key});

  @override
  Widget builder(
      BuildContext context, StartupViewModel viewModel, Widget? child) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Todo App',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) => StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) =>
      viewModel.runStartupLogic();
}
