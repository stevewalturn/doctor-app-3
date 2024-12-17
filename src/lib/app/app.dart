import 'package:my_app/features/auth/login/login_view.dart';
import 'package:my_app/features/auth/register/register_view.dart';
import 'package:my_app/features/dashboard/dashboard_view.dart';
import 'package:my_app/features/patients/list/patient_list_view.dart';
import 'package:my_app/features/patients/details/patient_details_view.dart';
import 'package:my_app/features/consultation/history/consultation_history_view.dart';
import 'package:my_app/features/consultation/new/new_consultation_view.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/authentication_service.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:my_app/ui/bottom_sheets/filters_sheet.dart';
import 'package:my_app/ui/dialogs/confirmation_dialog.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: LoginView, initial: true),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: PatientListView),
    MaterialRoute(page: PatientDetailsView),
    MaterialRoute(page: ConsultationHistoryView),
    MaterialRoute(page: NewConsultationView),
  ],
  dependencies: [
    InitializableSingleton(classType: ApiService),
    InitializableSingleton(classType: AuthenticationService),
    InitializableSingleton(classType: StorageService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
  ],
  bottomsheets: [
    StackedBottomsheet(classType: FiltersSheet),
  ],
  dialogs: [
    StackedDialog(classType: ConfirmationDialog),
  ],
)
class App {}
