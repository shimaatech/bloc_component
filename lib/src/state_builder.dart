import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc.dart';

/// Used for configuring default behavior on specific states for all
/// [StateBuilder]s
class StateBuilderConfig {
  /// Called when the state is a loading state (extends [StateLoading] )
  Widget onLoading(BuildContext context, StateLoading state) {
    return Container();
  }

  /// Called when the state is error state (extends [StateError])
  Widget onError(BuildContext context, StateError state) {
    return Text(state.message);
  }

  /// Called on any other state that is not a loading, error or success state
  Widget onOther(BuildContext context, BlocState state) {
    return Container();
  }
}

/// Built upon [BlocBuilder] class
/// Can be used for building a widget on a specific bloc state
///
/// Note: You don't need to use the StateBuilder directly (although you can),
/// most of the times (even always), you should use [ComponentView.stateBuilder]
/// method instead.
///
/// Example:
///
/// ```dart
/// StateBuilder<MyBloc, MyState>(
///   builder: (context, state) => onState(...)
/// );
///
/// ```
/// The state builder knows to handle loading and error states. Each state that
/// extends [StateLoading] will be considered as loading state, and the [onLoading]
/// callback will be called for it.
/// And each state that extends [StateError] will be considered as error state, and
/// the [onError] state will be called for it
/// ```
class StateBuilder<B extends BaseBloc, S extends BlocState>
    extends StatelessWidget {
  /// Builder config. Can be overridden simply by settings it to
  /// a new implementation of [StateBuilderConfig]
  static StateBuilderConfig builderConfig = StateBuilderConfig();

  /// Builder that will be called on when the state is [S]
  /// See [BlocBuilder.builder]
  final BlocWidgetBuilder<S> builder;

  /// The bloc to interact with. If not provided, it will be searched in the
  /// [BuildContext].
  /// See [BlocBuilderBase.bloc]
  final B bloc;

  /// The builder that will be called on any error state that extends [StateError]
  final BlocWidgetBuilder<StateError> onError;

  /// The builder that will be called on any loading state that extends [StateLoading]
  final BlocWidgetBuilder<StateLoading> onLoading;

  /// The builder tha will be called on any other state that is not [S], [StateLoading] or [StateError]
  final BlocWidgetBuilder<BlocState> onOther;

  /// Condition for calling the builder. Same as in [BlocBuilder]. Usually
  /// You don't need to override it. It will be automatically calculated
  /// according to the success, loading and error states.
  /// For more info about [condition], see [BlocBuilderBase.condition]
  final BlocBuilderCondition<BlocState> condition;

  /// Set it to true if you don't want to handle error state (your widget won't
  /// be rebuilt on error states that extend [StateError]).
  final bool skipError;

  /// Set it to true if you don't want to handle loading state (your widget won't
  /// be rebuilt on loading states that extend [StateLoading])
  final bool skipLoading;

  StateBuilder({
    @required this.builder,
    this.bloc,
    this.condition,
    this.onLoading,
    this.onError,
    this.onOther,
    this.skipError = false,
    this.skipLoading = false,
  });

  bool _isLoadingState(BlocState state) {
    return state is StateLoading;
  }

  bool _isErrorState(BlocState state) {
    return state is StateError;
  }

  bool _rebuildCondition(BlocState prev, BlocState current) {
    if (condition != null) {
      return condition(prev, current);
    }
    return (!skipLoading && _isLoadingState(current)) ||
        (!skipError && _isErrorState(current)) ||
        current is S;
  }

  @override
  Widget build(BuildContext context) {
    BlocWidgetBuilder<StateLoading> onLoadingBuilder =
        onLoading ?? builderConfig.onLoading;
    BlocWidgetBuilder<StateError> onErrorBuilder =
        onError ?? builderConfig.onError;
    BlocWidgetBuilder<BlocState> onOtherBuilder =
        onOther ?? builderConfig.onOther;

    return BlocBuilder<B, BlocState>(
      bloc: bloc,
      condition: _rebuildCondition,
      builder: (context, state) {
        if (_isLoadingState(state)) {
          return onLoadingBuilder(context, state);
        } else if (_isErrorState(state)) {
          return onErrorBuilder(context, state);
        } else if (state is! S) {
          return onOtherBuilder(context, state);
        }
        return builder(context, state);
      },
    );
  }
}
