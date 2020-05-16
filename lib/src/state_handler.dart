import 'package:flutter/material.dart';

import 'base_bloc.dart';

abstract class BlocStateHandler {
  Widget onLoading(StateLoading stateLoading);

  Widget onError(StateError stateError);

  Widget onOther(BlocState state);
}

class GlobalStateHandler {

  static BlocStateHandler _handler;

  static void setHandler(BlocStateHandler handler) {
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