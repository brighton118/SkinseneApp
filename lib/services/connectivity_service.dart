import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  /// Checks if the device currently has any active network connection.
  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    // In connectivity_plus version 6+, checkConnectivity returns a List<ConnectivityResult>
    return !result.contains(ConnectivityResult.none);
  }

  /// Stream to listen to real-time connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _connectivity.onConnectivityChanged;
}
