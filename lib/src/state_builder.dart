import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc.dart';

/// StateBuilderConfig
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


/// StateBuilder
/// Built upon the famous [BlocBuilder] class
/// Can be used for building a widget on a specific bloc state
///
/// Note: You don't need to use the StateBuilder directly (although you can),
/// most of the times (even always), you should use [ComponentView.stateBuilder]
/// and [ComponentView.stateBuilderWithLoading] methods instead.
///
/// Example:
///
/// ```dart
/// StateBuilder<MyBloc, MySuccessState, MyLoadingState, MyErrorState>(
///   builder: (context, success) => onSuccess(...)
///   onLoading: (context, loading) => onLoading(...)
///   onError: (context, error) => onError(...)
/// );
///
/// ```
///
/// If you are interested in the success state only, then pass [StateLoading]
/// and [StateError] to the loading and error states. In this case, the
/// StateBuilder won't be rebuilt when an error or loading states are emitted.
/// Example:
///
/// ```dart
/// StateBuilder<MyBloc, MySuccessState, StateLoading, StateError>(
///   builder: (context, success) => onSuccess(...)
/// );
/// ```
class StateBuilder<B extends BaseBloc, S extends BlocState,
    L extends StateLoading, E extends StateError> extends StatelessWidget {

  /// Builder config. Can be overridden simply by settings it to
  /// a new implementation of [StateBuilderConfig]
  static StateBuilderConfig builderConfig = StateBuilderConfig();

  /// Builder that will be called on the success state [S]
  /// See [BlocBuilder.builder]
  final BlocWidgetBuilder<S> builder;
  /// The bloc to interact with. If not provided, it will be searched in the
  /// [BuildContext]
  /// See [BlocBuilderBase.bloc]
  final B bloc;
  /// The builder that will be called on the error state [E]
  final BlocWidgetBuilder<E> onError;
  /// The builder that will be called on the loading state [L]
  final BlocWidgetBuilder<L> onLoading;
  /// The builder tha will be called on any other state
  final BlocWidgetBuilder<BlocState> onOther;
  /// Condition for calling the builder. Same as in [BlocBuilder]. Usually
  /// You don't need to override it. It will be automatically calculated
  /// according to the success, loading and error states that are provided.
  /// For more info about [condition], see [BlocBuilderBase.condition]
  final BlocBuilderCondition<BlocState> condition;

  StateBuilder({
    @required this.builder,
    this.bloc,
    this.condition,
    this.onLoading,
    this.onError,
    this.onOther,
  });


  bool _isLoadingState(BlocState state) {
    return L != StateLoading && state is L;
  }

  bool _isErrorState(BlocState state) {
    return E != StateError && state is E;
  }

  bool _rebuildCondition(BlocState prev, BlocState current) {
    if (condition != null) {
      return condition(prev, current);
    }
    return _isLoadingState(current) || _isErrorState(current) || current is S;
  }

  @override
  Widget build(BuildContext context) {
    BlocWidgetBuilder<L> onLoadingBuilder =
        onLoading ?? builderConfig.onLoading;
    BlocWidgetBuilder<E> onErrorBuilder =
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
