import 'package:stacked/stacked.dart';
import 'package:my_app/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = NavigationService();

  Future<void> navigateToTodos() async {
    try {
      await _navigationService.navigateTo(Routes.todoView);
    } catch (e) {
      setError('Navigation failed. Please try again.');
    }
  }
}
