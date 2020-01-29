
import 'package:bloc_component/bloc_component.dart';

import '../app_conetxt/app_context.dart';


class AppBloc extends BaseBloc {

  @override
  Stream<BlocState> eventToState(BlocEvent event) {
    // TODO: implement eventToState
    return null;
  }

  @override
  Stream<StateInitializing> initialize() async* {
    await AppContext.setup();
  }

}