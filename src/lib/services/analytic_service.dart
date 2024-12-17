import 'package:stacked/stacked_annotations.dart';

/// {@template analytics_service}
/// A wrapper for Analytics which encapsulates the implementation of
/// []
///
/// {@endtemplate}
class AnalyticService extends InitializableDependency {
  /// {@macro analytics_service}
  AnalyticService();

  @override
  Future<void> init() async {}
}
