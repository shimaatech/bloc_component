import 'package:bloc_component/bloc_component.dart';
import 'package:flutter/material.dart';
import '../pages/pages.dart';
import 'app_bloc.dart';

class AppHome extends Component<AppBloc> {
  @override
  ComponentView<AppBloc> createView(AppBloc bloc) {
    return AppHomeView(bloc);
  }

  @override
  AppBloc createBloc(BuildContext context) {
    return AppBloc();
  }

}

class AppHomeView extends ComponentView<AppBloc> {

  AppHomeView(AppBloc bloc) : super(bloc);

  @override
  Widget buildView(BuildContext context) {
    return MoviesPage();
  }

}