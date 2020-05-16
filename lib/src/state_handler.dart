import 'package:flutter/material.dart';

import 'base_bloc.dart';

abstract class BlocStateHandler {
  Widget onLoading(BuildContext context, StateLoading stateLoading);

  Widget onError(BuildContext context, StateError stateError);

  Widget onOther(BuildContext context, BlocState state);
}

class GlobalStateHandler {

  static BlocStateHandler _handler;

  static void setHandler(BlocStateHandler handler) {
    _handler = handler;
  }

  static Widget handle(BuildContext context, BlocState state) {
    assert (_handler != null);
    if (state is StateLoading) {
      return _handler.onLoading(context, state);
    } else if (state is StateError) {
      return _handler.onError(context, state);
    } else {
      return _handler.onOther(context, state);
    }
  }

}