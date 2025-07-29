import 'dart:async';

// State definition
enum ConnectivityState {
  initial,
  connectedWithInternet,
  connectedWithoutInternet,
  disconnected,
}

// Cubit definition
abstract class ConnectivityService {
  ConnectivityService();

  bool get isInternetOk;

  Future<void> waitUntilInitialized();

  /// Return the ID of the listener that will be used to remove it later.
  int addListener(void Function(ConnectivityState) listener);

  void removeListener(int listenerId);
}
