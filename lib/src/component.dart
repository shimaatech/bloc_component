import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc.dart';
import 'state_builder.dart';

/// Component
/// A user interface component that extends a [StatelessWidget]
/// A Component has its own bloc that extends [BaseBloc]
/// You need to tell the component how to create the bloc by overriding the
/// [createBloc] method and how to build the component view by overriding the
/// [createView] method
abstract class Component<B extends BaseBloc> extends StatelessWidget {

  Component({Key key}): super(key: key);

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
        builder: (context) {
          return BlocListener<B, BlocState>(
            listener: stateListener,
            child: createView(BlocProvider.of<B>(context)),
          );
        },
      ),
    );
  }

  /// Used for listening to bloc states.
  /// Can be used for logging, navigation or showing snack bars
  void stateListener(BuildContext context, BlocState state) {}
}

/// ComponentView
/// Responsible for building the view of a [Component]
/// It provides direct access to the bloc built by the [Component]
abstract class ComponentView<B extends BaseBloc> extends StatelessWidget {

  /// The component bloc
  final B bloc;

  ComponentView(this.bloc);

  /// The view to show while the bloc is initializing
  /// If progress is used, then it is passed to the [loadingData] state
  Widget onInitializing(BuildContext context, StateInitializing loadingData) =>
      StateBuilder.builderConfig.onLoading(context, loadingData);

  /// The view to show on bloc initialization error. The error info will be
  /// passed in the [error] state
  Widget onInitializingError(
          BuildContext context, StateInitializationError error) =>
      StateBuilder.builderConfig.onError(context, error);

  @override
  Widget build(BuildContext context) {
    return stateBuilderWithLoading<StateInitialized, StateInitializing,
        StateInitializationError>(
      builder: (context, state) => buildView(context),
      onLoading: onInitializing,
      onError: onInitializingError,
    );
  }

  /// stateBuilder
  /// A utility method that wraps the [StateBuilder] that can be used for
  /// building a widget on a specific state [S]
  /// Example:
  ///
  /// ```dart
  /// stateBuilder<MyState>(
  ///   builder: (context, state) => buildWidget(state.data)
  /// );
  /// ```
  ///
  /// In most cases, the only parameter that you need to pass to [stateBuilder]
  /// is the [builder] parameter.
  /// For more info about the parameters, check [stateBuilderWithLoading]
  Widget stateBuilder<S extends BlocState>({

    /// see [stateBuilderWithLoading]
    @required BlocWidgetBuilder<S> builder,

    /// see [stateBuilderWithLoading]
    BlocBuilderCondition<BlocState> condition,

    /// see [stateBuilderWithLoading]
    BlocWidgetBuilder<BlocState> onOther,

  }) {
    return stateBuilderWithLoading<S, StateLoading, StateError>(
      builder: builder,
      condition: condition,
      onOther: onOther,
    );
  }

  /// stateBuilderWithLoading
  /// A wrapper over [StateBuilder] that uses the component's [bloc]
  /// Can be used for building a widget based on a success state [S], a loading
  /// state [L] and an error state [E]
  /// If you don't want the widget to be rebuilt on error or loading, then use
  /// [stateBuilder] method instead of this method.
  /// If you want to handle errors, but not loading, then you can pass
  /// [StateLoading] as the loading state [S]
  ///
  /// Example:
  ///
  /// ```dart
  /// stateBuilderWithLoading<MySuccessState, MyLoadingState, MyErrorState>(
  ///   builder: (context, successState) => buildWidget(....)
  /// );
  /// ```
  ///
  /// Example for handling error state [E] only
  ///
  /// ```dart
  /// stateBuilderWithLoading<MySuccessState, StateLoading, MyErrorState>(
  ///   builder: (context, successState) => buildWidget(....)
  /// )
  /// ```
  Widget stateBuilderWithLoading<S extends BlocState, L extends StateLoading,
      E extends StateError>({

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
    BlocWidgetBuilder<L> onLoading,

    /// builder that is called when the state is error state [E]
    /// You can define a default error behavior by overriding
    /// [StateBuilder.builderConfig]
    /// See [StateBuilder.onError]
    BlocWidgetBuilder<E> onError,

    /// builder that is called when other state than [S] appears
    /// It's better to override [StateBuilder.builderConfig] for specifying
    /// the default [onOther] builder
    /// See [StateBuilder.onOther]
    BlocWidgetBuilder<BlocState> onOther,

  }) {
    return StateBuilder<B, S, L, E>(
      bloc: bloc,
      builder: builder,
      condition: condition,
      onLoading: onLoading,
      onError: onError,
      onOther: onOther,
    );
  }

  /// Must override this method in order to build the component's view
  Widget buildView(BuildContext context);
}
