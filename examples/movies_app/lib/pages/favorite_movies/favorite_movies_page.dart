import 'package:bloc_component/bloc_component.dart';
import 'package:flutter/material.dart';
import '../../app_conetxt/app_context.dart';
import '../../services/services.dart';
import '../base_page.dart';
import '../shared_components/shared_components.dart';
import 'favorite_movies_bloc.dart';


class FavoriteMoviesPage extends BasePage {

  @override
  Widget buildContent(BuildContext context) {
    return FavoriteMoviesComponent();
  }

  @override
  List<Widget> appBarActions(BuildContext context) => [];

  @override
  String get title => 'Favorite Movies';

}

class FavoriteMoviesComponent extends Component<FavoriteMoviesBloc> {
  @override
  ComponentView<FavoriteMoviesBloc> createView(FavoriteMoviesBloc bloc) {
    return FavoriteMoviesView(bloc);
  }

  @override
  FavoriteMoviesBloc createBloc(BuildContext context) {
    return FavoriteMoviesBloc(AppContext.locate<MoviesServices>());
  }
}

class FavoriteMoviesView extends ComponentView<FavoriteMoviesBloc> {
  FavoriteMoviesView(FavoriteMoviesBloc bloc) : super(bloc);

  @override
  Widget buildView(BuildContext context) {
    return stateBuilder<FavoriteMoviesStateUpdated>(builder: (context, state) {
      return ListView.builder(
        itemCount: state.movies.length,
        itemBuilder: (context, index) => MovieItem(state.movies[index]),
      );
    });
  }
}
