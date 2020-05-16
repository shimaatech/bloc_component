import 'package:flutter/material.dart';

import 'base_bloc.dart';

abstract class StateHandler {
  Widget onLoading(StateLoading stateLoading);

  Widget onError(StateError stateError);

  Widget onOther(BlocState state);
}

class GeneralStatesHandler {

  static StateHandler _handler;

  static void setHandler(StateHandler handler) {
    _handler = handler;
  }

  static Widget handle(BlocState state) {
    assert (_handler != null);
    if (state is StateLoading) {
      return _handler.onLoading(state);
    } else if (state is StateError) {
      return _handler.onError(state);
    } else {
      return _handler.onOther(state);
    }
  }

}