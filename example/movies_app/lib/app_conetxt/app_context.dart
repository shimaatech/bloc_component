import 'package:kiwi/kiwi.dart' as kiwi;

import '../repositories/repositories.dart';
import '../services/services.dart';

class AppContext {
  static final kiwi.Container _locator = kiwi.Container();

  static T locate<T>([String name]) => _locator.resolve<T>(name);

  static Future<void> setup() async {
    _locator.registerSingleton((locator) => MoviesRepository());

    _locator.registerSingleton(
        (locator) => MoviesServices(locator.resolve<MoviesRepository>()));
  }
}
