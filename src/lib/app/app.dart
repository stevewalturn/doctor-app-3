import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:my_app/repositories/auth_repository.dart';
import 'package:my_app/repositories/patient_repository.dart';
import 'package:my_app/repositories/consultation_repository.dart';
import 'package:my_app/features/auth/login/login_view.dart';
import 'package:my_app/features/auth/register/register_view.dart';
import 'package:my_app/features/dashboard/dashboard_view.dart';
import 'package:my_app/features/patients/patient_list/patient_list_view.dart';
import 'package:my_app/features/patients/patient_details/patient_details_view.dart';
import 'package:my_app/features/consultation/consultation_form/consultation_form_view.dart';
import 'package:my_app/features/consultation/consultation_history/consultation_history_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: LoginView, initial: true),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: PatientListView),
    MaterialRoute(page: PatientDetailsView),
    MaterialRoute(page: ConsultationFormView),
    MaterialRoute(page: ConsultationHistoryView),
  ],
  dependencies: [
    InitializableSingleton(classType: ApiService),
    InitializableSingleton(classType: AuthService),
    InitializableSingleton(classType: StorageService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: AuthRepository),
    LazySingleton(classType: PatientRepository),
    LazySingleton(classType: ConsultationRepository),
  ],
)
class App {}
