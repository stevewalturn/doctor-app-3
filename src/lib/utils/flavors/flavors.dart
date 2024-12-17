import 'package:my_app/models/enums/flavor.dart';

/// {@template flavors}
/// Stores current app flavor.
/// {@endtemplate}
class Flavors {
  /// {@macro flavors}
  factory Flavors() => _instance;

  Flavors._();

  static final _instance = Flavors._();

  static Flavor? flavor;

  static bool get isDev => flavor == Flavor.development;

  static bool get isProd => flavor == Flavor.production;
}
