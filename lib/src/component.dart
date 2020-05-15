import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'base_bloc.dart';

class ComponentArgs {}

/// A UI component that extends a [StatelessWidget].
/// A Component has its own bloc that extends [BaseBloc]
/// You need to tell the component how to create the bloc by overriding the
/// [createBloc] method and how to build the component view by overriding the
/// [createView] method
abstract class Component<B extends BaseBloc> extends StatelessWidget {

  Component({Key key}) : super(key: key);

  /// Used for creating the component's bloc
  B createBloc(BuildContext context);

  void disposeBloc(BuildContext context, BaseBloc bloc) => bloc.close();

  /// Used for creating the component's view. A [bloc] is passed to this method
  /// so that it can be passed to the created [ComponentView]
  ComponentView<B> createView(B bloc);

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<B>(
      key: key,
      create: createBloc,
      dispose: disposeBloc,
      child: Builder(
        builder: _viewBuilder,
      ),
    );
  }

  Widget _viewBuilder(BuildContext context) {
    return createView(Provider.of<B>(context));
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, BlocState>(
      bloc: bloc,
      listener: stateListener,
      child: buildView(context),
    );
  }

  /// Must override this method in order to build the component's view
  Widget buildView(BuildContext context);
}
