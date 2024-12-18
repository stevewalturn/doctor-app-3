import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/ui/common/app_colors.dart';
import 'package:my_app/ui/common/ui_helpers.dart';
import 'package:my_app/features/startup/startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, StartupViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/steve.png',
              width: 150,
              height: 150,
            ),
            verticalSpaceMedium,
            const Text(
              'MY TODO APP',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: kcPrimaryColor,
              ),
            ),
            verticalSpaceMedium,
            if (viewModel.hasError)
              Text(
                viewModel.modelError.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            if (!viewModel.hasError)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kcPrimaryColor),
              ),
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
