
import 'package:bloc_component/bloc_component.dart';

import '../app_conetxt/app_context.dart';

class AppState extends BlocState {}

class AppEvent extends BlocEvent {}

class AppBloc extends BaseBloc<AppEvent, AppState> {

  @override
  Stream<AppState> eventToState(AppEvent event) {
    // TODO: implement eventToState
    return null;
  }

  @override
  Stream<StateInitializing> initialize() async* {
    await AppContext.setup();
  }

}