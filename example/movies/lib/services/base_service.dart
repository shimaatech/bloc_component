import 'package:flutter/cupertino.dart';

abstract class BaseService {

  Future<void> _initialized;
  Future<void> get initialized => _initialized;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @protected
  Future<void> initialize();

  @mustCallSuper
  BaseService() {
    _initialize();
  }

  void dispose() {}

  Future<void> _initialize() async {
    _initialized = initialize();
    await _initialized;
    _isInitialized = true;
  }

}