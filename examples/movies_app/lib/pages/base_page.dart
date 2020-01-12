import 'package:flutter/material.dart';
import 'pages.dart';

abstract class BasePage extends StatelessWidget {

  Widget buildContent(BuildContext context);

  List<Widget> appBarActions(BuildContext context) => [
        favoriteMoviesActionButton(context),
      ];

  String get title => 'Movies App';

  @override
  Widget build(BuildContext context) {
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

}
