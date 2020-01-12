# bloc_component

A library that helps structuring flutter apps using the BLoC library.  
It makes it easier to:
- structure your app into components and manage the state of each component separately.
- Maintain your app
- Add new pages and features


### Links
- [pub.dev package](https://pub.dev/packages/bloc_component)
- [github repository](https://github.com/shimaatech/bloc_component)
- [API reference](https://pub.dev/documentation/bloc_component/latest/bloc_component/bloc_component-library.html)


## Getting Started

This library is built upon the flutter [bloc](https://pub.dev/packages/bloc) library.
It allows developers to structure their app into components, where each component has its own bloc.


## Examples

[Movies App](https://github.com/shimaatech/bloc_component/tree/master/examples)

![Movies App demo](https://media.giphy.com/media/eIyX1CUFzQkgjV8IMG/giphy.gif)


## Library contents

The library provides the following components in order to help structuring and manging the state
of a flutter app:
- `BaseBloc`: Used for managing the state of an app component
- `Componen`: Describes an app component. Can be a page or part of page. Each component has its
own bloc. The `Component` describes how to create the bloc and the component's view
- `ComponentView`: The component's view. Has direct access to the bloc created by the `Component`
and uses `StateBuilder` in order to build widgets according to the bloc's states

### `BaseBloc`

The `BaseBloc` class is the class that each bloc should inherit from. It inherits from the `Bloc`
class of the `bloc` library.
The `BaseBloc` class adds additional functionality like initialization and error handling.

Example of `MovieItemBloc` that inherits from `BaseBloc`:  
For the full example, please check the [Movies App example](https://github.com/shimaatech/bloc_component/tree/master/examples)
 in the library repository

```dart
// First we need to create the base bloc state which should extend from BlocState
class MovieItemState extends BlocState {}

// Then we create other states that are specific to this bloc
// The MovieItemStateFavoriteUpdated, is yielded when the movie is added or removed from the
// favorite list
class MovieItemStateFavoriteUpdated extends MovieItemState {
  final bool isFavorite;

  MovieItemStateFavoriteUpdated(this.isFavorite);

  @override
  List<Object> get props => [isFavorite];
}


// we need to define a base bloc event that inherits from BlocEvent
class MovieItemEvent extends BlocEvent {}

// Then we need to create events that are specific to this bloc.
// MovieItemEventToggleFavorite is used for adding/removing movie from the favorite list
class MovieItemEventToggleFavorite extends MovieItemEvent {}


// Here we define the bloc. It extends BaseBloc which receives MovieItemEvent and yields
// MovieItemState.
// This bloc is used for managing the state of a single movie item in the movies list
class MovieItemBloc extends BaseBloc<MovieItemEvent, MovieItemState> {
  final MoviesServices _moviesServices;
  final Movie movie;

  // This bloc depends on movies services and a specific movie
  MovieItemBloc(this._moviesServices, this.movie);

  // We need to override this eventToState() method in order to handle events and change the state
  // of the bloc
  @override
  Stream<MovieItemState> eventToState(MovieItemEvent event) async* {
    if (event is MovieItemEventToggleFavorite) {
      yield* _toggleFavorite();
    }
  }

  // We need to override the onInitialized() method in order to yield some state or add some
  // event upon bloc initialization
  @override
  Stream<MovieItemState> onInitialized() async* {
    yield* _notifyFavoriteUpdated();
  }

  // We need to override the initialize() method if there is a need to initialize anything when
  // the bloc is created
  @override
  Stream<StateInitializing> initialize() async* {
    // here we wait until the movies service is initialized
    await _moviesServices.initialized;
  }

  // This method handles the toggle favorite event. If the movie is in favorite list, then it is
  // removed, otherwise it's added to the favorite list
  Stream<MovieItemState> _toggleFavorite() async* {
    if (_moviesServices.isFavorite(movie)) {
      await _moviesServices.removeFavoriteMovie(movie);
    } else {
      await _moviesServices.addFavoriteMovie(movie);
    }
    // in the end we notify listeners by yielding the new state
    yield* _notifyFavoriteUpdated();
  }

  // a shortcut method for changing the state to MovieItemStateFavoriteUpdated in order to notify
  // listeners that the favorite state of the movie has changed
  Stream<MovieItemStateFavoriteUpdated> _notifyFavoriteUpdated() async* {
    yield MovieItemStateFavoriteUpdated(_moviesServices.isFavorite(movie));
  }


}
```


### `Component`
The `Component` class is a `StatelessWidget` that is attached to one `bloc`. The component just
describes how to create the `bloc` and how to create the `view` of this component.  
Another utility that is provided by the `Component` class, is the `stateListener` which allows
listening to state changes from the `bloc` that is attached to the `component`. The `stateListener`
is simply a `BlocListener` from the `BLoC` library.  


An Example of a `Component` that uses the `MovieItemBloc` from the example above:  
For the full example, please check the [Movies App example](https://github.com/shimaatech/bloc_component/tree/master/examples)
 in the library repository


```dart
/// A MovieItem component that is used for showing a single component.
/// The bloc that is used by this component is the MovieItemBloc
class MovieItem extends Component<MovieItemBloc> {
  final Movie movie;

  MovieItem(this.movie);

  @override
  MovieItemBloc createBloc(BuildContext context) {
    // in this method we create the MovieItemBloc
    return MovieItemBloc(MoviesServices.getInstance(), movie);
  }

  @override
  ComponentView<MovieItemBloc> createView(MovieItemBloc bloc) {
    // in this method we create the component view and pass it the created bloc
    return MovieItemView(bloc);
  }
  
  
  // override the stateListener method if you need to listen to states from the created bloc
  // (MovieItemBloc in our case).
  // Note that this is a listener and not a builder. It's useful for logging, navigation,
  // showing snack bars...
  @override
  void stateListener(BuildContext context, BlocState state) {
    if (state is StateError) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

}
```


### `ComponentView`

The `ComponentView` is used for building the view of the `component`. It has direct access to the
`bloc` created by the `component`, and it has some utilities for managing the state easily
using the `stateBuilder`  
You can also handle bloc initialization, and errors in the `ComponentView`. Check the [Movies App example](https://github.com/shimaatech/bloc_component/tree/master/examples)
 in the repository for more info

An Example of a `ComponentView` for the `MovieItem` component from the example above:  
For the full example, please check the [Movies App example](https://github.com/shimaatech/bloc_component/tree/master/examples)
 in the library repository

```dart
/// The view of the MovieItem component
class MovieItemView extends ComponentView<MovieItemBloc> {
  MovieItemView(MovieItemBloc bloc) : super(bloc);

  // This method builds the content of the component's view
  @override
  Widget buildView(BuildContext context) {
    final Movie movie = bloc.movie;
    return ListTile(
      leading: Image.network(movie.imageUrl),
      title: Text(movie.title),
      subtitle: Text(movie.year.toString()),
      trailing: _buildFavoriteIcon(),
    );
  }

  Widget _buildFavoriteIcon() {
    // The only state that is managed by the BlocItemBloc is the favorite state
    // Here we use a stateBuilder for rebuilding the favorite icon when the state is changed to
    // MovieIemStateFavoriteUpdated
    return stateBuilder<MovieItemStateFavoriteUpdated>(
        builder: (context, state) {
          return GestureDetector(
            child: Icon(state.isFavorite ? Icons.star : Icons.star_border),
            // When tapping the favorite icon, a MovieItemEventToggleFavorite event is dispatched
            onTap: () => bloc.event(MovieItemEventToggleFavorite()),
          );
        });
  }
}
```


The `ComponentView` class also allows to handle bloc initialization and errors.  
Here is an example for handling initialization and error while initializing the `MoviesView`

```dart
/// Creates the view for the MoviesComponent
class MoviesView extends ComponentView<MoviesBloc> {

  MoviesView(MoviesBloc bloc) : super(bloc);

  // override onInitializing() method in order to show something while the component's bloc is
  // being initialized
  @override
  Widget onInitializing(BuildContext context, StateInitializing loadingData) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Loading movies...'),
            LinearProgressIndicator(
              value: loadingData.progress,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget onInitializingError(BuildContext context, StateInitializationError error) {
    return Text("An error occurred while initializing movies: ${error.message}");
  }


  @override
  Widget buildView(BuildContext context) {
    ...
  }
}

```


### More on `stateBuilder`

`stateBuilder` is utility method provided by the `ComponentView` which helps in building and
rebuilding widgets according to state changes. It wraps the `StateBuilder` class which wraps
the `BlocBuilder` class of the [bloc](https://pub.dev/packages/bloc) library

The `ComponentView` class provides 2 types of `stateBuilder`:

#### `stateBuilder`
A state builder that calls the builder only on a specific state

```dart
  /// Used for building a widget on specific state S
  /// In most cases, the only parameter that you need to pass to the stateBuilder is the builder
  /// for building the widget when the bloc state is S
  Widget stateBuilder<S extends BlocState>({
    
    /// The builder to be called when the state is S
    @required BlocWidgetBuilder<S> builder,

    /// Condition for rebuilding widget. Same is the condition in the BlocBuilder of the BLoC
    /// library. In most cases you don't need to provide the condition as its default is
    /// "state is S"
    BlocBuilderCondition<BlocState> condition,

    /// The builder to be called another state rather than S is met. You don't need to pass
    /// this parameter if you don't change the condition. And you can set a default builder
    /// as explained later.
    BlocWidgetBuilder<BlocState> onOther,

  })
```


#### `stateBuilderWithLoading`

This is the second type of state builder. It allows listening to loading and error states also
For this you need to define a state that extends the `StateLoading` or the `StateError` mixin
If you don't want to listen to error state, then you can pass StateError for error state E.
If you don'tt want to listen to loading state, then you can pass StateLoading for loading state L.

```dart
  /// Allows building a widget on a specific state while taking care of loading and error states
  Widget stateBuilderWithLoading<S extends BlocState, L extends StateLoading,
      E extends StateError>({

    /// The builder to be called when the state is S
    @required BlocWidgetBuilder<S> builder,

    /// The bloc rebuild condition... Usually there is no need to pass a
    /// condition as by default it will be rebuilt when one of he states S, L or E are met 
    BlocBuilderCondition<BlocState> condition,

    /// builder that is called when the state is a loading state L
    /// You can define a default loading behavior by overriding [StateBuilder.builderConfig]
    BlocWidgetBuilder<L> onLoading,

    /// builder that is called when the state is error state [E]
    /// You can define a default error behavior by overriding [StateBuilder.builderConfig]
    BlocWidgetBuilder<E> onError,

    /// builder that is called when another state rather than [S] appears
    /// It's better to override [StateBuilder.builderConfig] for specifying
    /// the default [onOther] builder
    BlocWidgetBuilder<BlocState> onOther,

  })
```


#### An example of using `stateBuilderWithLoading`

Let's assume that adding or removing a favorite movie takes some time. And you need to show the user
that adding/removing favorite movie is in progress.  
We can add the following state to the `MovieItemBloc`:

```dart
// A state that indicates that updating a favorite movie is in progress...
// Please note that this state is extending the StateLoading state so that it can be used with
// stateBuilderWithLoading
class MovieItemStateUpdatingFavorite extends MovieItemState with StateLoading {}
```

We need to update the `_toggleFavorite()` method in order to yield our new state before updating
the favorite status of the movie

```dart
  Stream<MovieItemState> _toggleFavorite() async* {
    // notify that movie favorite status is being updated
    yield MovieItemStateUpdatingFavorite();
    if (_moviesServices.isFavorite(movie)) {
      await _moviesServices.removeFavoriteMovie(movie);
    } else {
      await _moviesServices.addFavoriteMovie(movie);
    }
    yield* _notifyFavoriteUpdated();
  }
```

In the `_buildFavoriteIcon()` method of the `movieItemView`, we need to use `stateBuilderWithLoading` instead of `stateBuilder`:

```dart
  Widget _buildFavoriteIcon() {
    // use stateBuilderWithLoading and pass MovieItemStateUpdatingFavorite as a loading state.
    // notice that we pass StateError as the error state because we are not interested in error
    // states. Note that we pass onLoading parameter
    return stateBuilderWithLoading<MovieItemStateFavoriteUpdated,
            MovieItemStateUpdatingFavorite, StateError>(
        // show a CircularProgressIndicator on loading. If you don't pass onLoading builder, then
        // the default builder that is defined by the StateBuilder.builderConfig is used
        onLoading: (context, loadingState) => CircularProgressIndicator(),
        builder: (context, state) {
          return GestureDetector(
            child: Icon(state.isFavorite ? Icons.star : Icons.star_border),
            onTap: () => bloc.event(MovieItemEventToggleFavorite()),
          );
        });
  }
``` 


### `StateBuilder` config

You can set default builders for onLoading, onError and onOther.  
To do this, you need to extend `StateBuilderConfig` and pass an instance of it to `StateBuilder.builderConfig`.  

**Example**:

```dart
class AppStateBuilderConfig extends StateBuilderConfig {
  @override
  Widget onError(BuildContext context, StateError error) {
    return Text(error.message);
  }
  
  @override
  Widget onLoading(BuildContext context, StateLoading loading) {
    return Center(child: CircularProgressIndicator(),);
  }
  
  @override
  Widget onOther(BuildContext context, BlocState state) {
    return Center(child: CircularProgressIndicator(),);
  }
}
```

And in your main method simply override `StateBuilder.builderConfig`:

```dart
void main() {
  StateBuilder.builderConfig = AppStateBuilderConfig();
  runApp(MyApp());
}
```

## Examples

- [Simple Movies App](https://github.com/shimaatech/bloc_component/tree/master/examples)


![Movies App demo](https://media.giphy.com/media/eIyX1CUFzQkgjV8IMG/giphy.gif)


For more info please refer to the [docs](https://pub.dev/documentation/bloc_component/latest) and [API reference](https://pub.dev/documentation/bloc_component/latest/bloc_component/bloc_component-library.html)
