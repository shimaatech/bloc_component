import 'package:flutter/cupertino.dart';

abstract class BaseService {

  Future<void> _initialized;
  Future<void> get initialized => _initialized;

  @protected
  Future<void> initialize();

  @mustCallSuper
  BaseService() {
    _initialized = initialize();
  }

  void dispose() {}

}