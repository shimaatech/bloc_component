import 'package:bloc_component/bloc_component.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import 'app/app.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  StateBuilder.builderConfig = AppStateBuilderConfig();
  runApp(MoviesApp());
}


class AppStateBuilderConfig extends StateBuilderConfig {
  @override
  Widget onError(BuildContext context, StateError error) {
    return Text(error.message);
  }

  @override
  Widget onLoading(BuildContext context, StateLoading loading) {
    return Center(child: CircularProgressIndicator(),);
  }

  @override
  Widget onOther(BuildContext context, BlocState state) {
    return Center(child: CircularProgressIndicator(),);
  }
}


class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('$bloc: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('$bloc: $transition');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('$bloc: $error');
  }
}
