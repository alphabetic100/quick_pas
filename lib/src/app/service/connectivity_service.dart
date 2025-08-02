import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._internal();
  late StreamController<bool> _connectionController;
  late StreamSubscription _connectivitySubscription;
  bool _isConnected = false;

  factory ConnectivityService() {
    return instance;
  }

  ConnectivityService._internal() {
    _connectionController = StreamController<bool>.broadcast();
    _init();
  }

  Stream<bool> get connectionStream => _connectionController.stream;
  bool get isConnected => _isConnected;

  Future<void> _init() async {
    final connectivity = Connectivity();
    
    final result = await connectivity.checkConnectivity();
    _updateConnectionStatus(result);

    _connectivitySubscription = connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected = results.any((result) => 
      result == ConnectivityResult.wifi || 
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.ethernet
    );
    
    if (wasConnected != _isConnected) {
      log('Connection status changed: $_isConnected');
      _connectionController.add(_isConnected);
    }
  }

  void dispose() {
    _connectivitySubscription.cancel();
    _connectionController.close();
  }
}

final connectivityProvider = StreamProvider<bool>((ref) {
  return ConnectivityService.instance.connectionStream;
});

final isConnectedProvider = Provider<bool>((ref) {
  return ConnectivityService.instance.isConnected;
});
