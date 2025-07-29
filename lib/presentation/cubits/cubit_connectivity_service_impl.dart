import 'package:budget_zise/data/services/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:io';

class CubitConnectivityServiceImpl extends Cubit<ConnectivityState>
    implements ConnectivityService {
  final List<void Function(ConnectivityState)> _listeners;

  CubitConnectivityServiceImpl()
    : _listeners = [],
      super(ConnectivityState.initial) {
    Connectivity().onConnectivityChanged.listen(_checkRealInternetAccess);
  }

  Future<void> _checkRealInternetAccess(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn)) {
      try {
        // Check if there's actual internet access
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          emit(ConnectivityState.connectedWithInternet);
        } else {
          emit(ConnectivityState.connectedWithoutInternet);
        }
      } on SocketException catch (_) {
        // No internet connection
        emit(ConnectivityState.connectedWithoutInternet);
      }
    } else {
      emit(ConnectivityState.disconnected);
    }
  }

  @override
  void emit(ConnectivityState state) {
    // Notify all listeners about the new state
    for (final listener in _listeners) {
      listener(state);
    }

    if (isClosed) return; // Prevent emitting state if the cubit is closed
    super.emit(state);
  }

  @override
  Future<void> waitUntilInitialized() async {
    if (state == ConnectivityState.initial) {
      // Wait until the state is not initial
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        return state == ConnectivityState.initial;
      });
    }
  }

  @override
  bool get isInternetOk {
    return state == ConnectivityState.connectedWithInternet;
  }

  /// Return the ID of the listener that will be used to remove it later.
  @override
  int addListener(void Function(ConnectivityState) listener) {
    _listeners.add(listener);
    return _listeners.length - 1; // Return the index of the listener
  }

  @override
  void removeListener(int listenerId) {
    if (_listeners.length <= listenerId || listenerId < 0) {
      throw ArgumentError('Invalid listener ID: $listenerId');
    }
    _listeners.removeAt(listenerId);
  }
}
