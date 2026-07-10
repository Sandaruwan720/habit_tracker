import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Monitors network availability and broadcasts connection state changes.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Stream that emits `true` when online, `false` when offline.
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Begin listening for connectivity changes.
  void initialize() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _controller.add(_isOnline(results));
    });
  }

  /// Checks the current connectivity state once.
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return _isOnline(results);
  }

  bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
