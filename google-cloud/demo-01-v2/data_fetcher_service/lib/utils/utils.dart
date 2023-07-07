import 'dart:io';
import 'package:path/path.dart' as p;

/// An extension on [String] that provides a method to clean the value by removing double quotes and trimming whitespace.
extension CleanBodyResponse on String {
  /// Cleans the string value by removing double quotes and trimming whitespace.
  ///
  /// Returns the cleaned string value.
  String cleanValue() => replaceAll('"', '').trim();
}

/// Checks if the code is running inside a Docker container.
///
/// Returns an empty string if the code is running inside a Docker container, or the string 'assets' if it's not running in a Docker container.
String isRunningInDockerContainer() =>
    Platform.environment["FETCHER_SERVICE_IN_DOCKER"] == 'true' ? '' : 'assets';

/// Retrieves the API key from a file.
///
/// Returns the API key as a [String].
String getApiKey() => File(p.join(
      Directory.current.path,
      isRunningInDockerContainer(),
      'sa-key-api',
    )).readAsStringSync();

/// Retrieves the service account key from a file.
///
/// Returns the service account key as a [String].
String getSAKey() => File(p.join(
      Directory.current.path,
      isRunningInDockerContainer(),
      'sa-key.json',
    )).readAsStringSync();

/// Retrieves the stocks configuration from a json file
///
/// Returns the config as a [String].
String getStockConfig() => File(p.join(
      Directory.current.path,
      isRunningInDockerContainer(),
      'us_stocks.json',
    )).readAsStringSync();

Map<String, dynamic> mergeJson(
    Map<String, dynamic> json1, Map<String, dynamic> json2) {
  final Map<String, dynamic> mergedJson = {};
  mergedJson.addAll(json1);
  mergedJson.addAll(json2);
  return mergedJson;
}
