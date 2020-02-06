import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc.dart';
import 'state_builder.dart';

/// A UI component that extends a [StatelessWidget].
/// A Component has its own bloc that extends [BaseBloc]
/// You need to tell the component how to create the bloc by overriding the
/// [createBloc] method and how to build the component view by overriding the
/// [createView] method
abstract class Component<B extends BaseBloc> extends StatelessWidget {
  Component({Key key}) : super(key: key);

  /// Used for creating the component's bloc
  B createBloc(BuildContext context);

  /// Used for creating the component's view. A [bloc] is passed to this method
  /// so that it can be passed to the created [ComponentView]
  ComponentView<B> createView(B bloc);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      key: key,
      create: createBloc,
      child: Builder(
        builder: _viewBuilder,
      ),
    );
  }

  Widget _viewBuilder(BuildContext context) {
    return createView(BlocProvider.of<B>(context));
  }
}

/// Responsible for building the view of a [Component]
/// It provides direct access to the bloc built by the [Component]
abstract class ComponentView<B extends BaseBloc> extends StatelessWidget {
  /// The component bloc
  final B bloc;

  ComponentView(this.bloc);

  /// Used for listening to bloc states.
  /// Can be used for logging, navigation or showing snack bars
  void stateListener(BuildContext context, BlocState state) {}

  /// The view to show while the bloc is initializing
  /// If progress is used, then it is passed to the [loadingData] state
  Widget onInitializing(BuildContext context, StateLoading loadingData) =>
      StateBuilder.builderConfig.onLoading(context, loadingData);

  /// The view to show on bloc initialization error. The error info will be
  /// passed in the [error] state
  Widget onInitializingError(BuildContext context, StateError error) =>
      StateBuilder.builderConfig.onError(context, error);

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, BlocState>(
      bloc: bloc,
      listener: stateListener,
      child: bloc.initialState is StateUninitialized
          ? _initializeAndBuild(context)
          : buildView(context),
    );
  }

  /// A wrapper over [StateBuilder] that uses the component's [bloc]
  /// Can be used for building a widget based on a success state [S], a loading
  /// state [L] and an error state [E]
  /// If you don't want the widget to be rebuilt on error or loading, then set
  /// [skipError] or [skipLoading] to true accordingly
  ///
  /// Example:
  ///
  /// ```dart
  /// stateBuilderWithLoading<MyState>(
  ///   builder: (context, state) => buildWidget(....)
  /// );
  /// ```
  ///
  Widget stateBuilder<S extends BlocState>({
    /// The builder to be called when the state [S] is yielded
    /// See [StateBuilder.builder]
    @required BlocWidgetBuilder<S> builder,

    /// The bloc rebuild condition... Usually there is no need to pass a
    /// condition as by default it will be rebuilt when the success state [S]
    /// is emitted
    /// See [StateBuilder.condition]
    BlocBuilderCondition<BlocState> condition,

    /// builder that is called when the state is a loading state [L]
    /// You can define a default loading behavior by overriding
    /// [StateBuilder.builderConfig]
    /// See [StateBuilder.onLoading]
    BlocWidgetBuilder<StateLoading> onLoading,

    /// builder that is called when the state is error state [E]
    /// You can define a default error behavior by overriding
    /// [StateBuilder.builderConfig]
    /// See [StateBuilder.onError]
    BlocWidgetBuilder<StateError> onError,

    /// builder that is called when other state than [S] appears
    /// It's better to override [StateBuilder.builderConfig] for specifying
    /// the default [onOther] builder
    /// See [StateBuilder.onOther]
    BlocWidgetBuilder<BlocState> onOther,

    /// Set to true in order to not rebuild the widget on errors ([onError] won't
    /// be called when there is an error.
    /// See [StateBuilder.skipError]
    bool skipError = false,

    /// Set to true in order to not rebuild the widget on loading states
    /// ([onLoading] won't be called when there is a loading state.
    /// See [StateBuilder.skipLoading]
    bool skipLoading = false,
  }) {
    return StateBuilder<B, S>(
      bloc: bloc,
      builder: builder,
      condition: condition,
      onLoading: onLoading,
      onError: onError,
      onOther: onOther,
      skipError: skipError,
      skipLoading: skipLoading,
    );
  }

  /// Must override this method in order to build the component's view
  Widget buildView(BuildContext context);

  Widget _initializeAndBuild(BuildContext context) {
    return stateBuilder<StateInitialized>(
        condition: (prev, curr) =>
            curr is StateInitialized ||
            curr is StateInitializing ||
            curr is StateInitializationError,
        builder: (context, state) => buildView(context),
        onLoading: onInitializing,
        onError: onInitializingError);
  }
}
