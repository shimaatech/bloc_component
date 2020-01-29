import 'package:bloc_component/bloc_component.dart';
import 'package:flutter/material.dart';
import 'pages.dart';

abstract class BasePageView<B extends BaseBloc> extends ComponentView <B>{
  BasePageView(B bloc) : super(bloc);

  Widget buildContent(BuildContext context);

  List<Widget> appBarActions(BuildContext context) => [
        favoriteMoviesActionButton(context),
      ];

  String get title => 'Movies App';

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: appBarActions(context),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: buildContent(context),
      ),
    );
  }

  @protected
  Widget favoriteMoviesActionButton(BuildContext context) {
    return GestureDetector(
      child: Icon(Icons.favorite),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => FavoriteMoviesPage())),
    );
  }

  @override
  Widget onInitializing(BuildContext context, StateLoading loadingData) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: onPageInitializing(context, loadingData),
    );
  }

  @protected
  Widget onPageInitializing(BuildContext context, StateLoading loadingData) {
    return super.onInitializing(context, loadingData);
  }

}
