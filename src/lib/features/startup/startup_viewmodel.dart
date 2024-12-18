import 'package:stacked/stacked.dart';
import 'package:my_app/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = NavigationService();

  Future<void> runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      await _navigationService.clearStackAndShow(Routes.todoView);
    } catch (e) {
      setError('Failed to initialize the application. Please restart the app.');
    }
  }
}
