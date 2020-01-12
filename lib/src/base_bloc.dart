import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

/// BlocState
/// All states must inherit from [BlocState]
abstract class BlocState implements Equatable {
  @override
  List<Object> get props => [];
}

/// StateInitial
/// The initial state of any bloc that extends [BaseBloc]
class StateInitial extends BlocState {}

/// StateLoading
/// Each state that needs to allow loading functionality to be used with
/// the [StateBuilder] must be implemented with [StateLoading]
mixin StateLoading implements BlocState {}

/// StateError
/// Each state that needs tto allow error functionality to be used with the
/// [StateBuilder[ must be implemented with [StateError]
mixin StateError implements BlocState {
  String get message;
}


/// StateInitializing
/// A state that indicates that the bloc is being initialized. Allows reporting
/// [progress] of initializing
/// This state is implemented with [StateLoading] so that it can be used as
/// a loading state with the [StateBuilder]
class StateInitializing with StateLoading {
  final double progress;

  StateInitializing([this.progress]);

  @override
  List<Object> get props => [progress];

}


/// StateInitializationError
/// Emitted when there is an issue with initializing the bloc. It contains
/// the error [message], [exception] and [stacktrace]
/// This state is implemented with [StateError] so that it can be used as an
/// error state with the [StateBuilder]
class StateInitializationError with StateError {
  final String message;
  final Object exception;
  final StackTrace stacktrace;

  StateInitializationError(this.message, [this.exception, this.stacktrace]);

  @override
  List<Object> get props => [message, exception];

}

/// StateInitialized
/// A state that indicates that the bloc is initialized
class StateInitialized extends BlocState {}


/// Base bloc event
/// All events must inherit from [BlocEvent]
class BlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// InitializeEvent
/// An event for initializing the blocs that inherit from [BaseBloc]
/// This event is dispatched when the bloc is created
class InitializeEvent extends BlocEvent {}


/// A base bloc that extends the Bloc class for providing additional
/// functionality. When the bloc is created, and [InitializeEvent] is dispatched.
/// In order to do some initializations, you can override the [initialize] method
/// If you need to yield some state upon initialization, then you can use the
/// [onInitialized] method
abstract class BaseBloc<E extends BlocEvent, S extends BlocState>
    extends Bloc<BlocEvent, BlocState> {

  bool _initialized = false;

  BaseBloc() {
    super.add(InitializeEvent());
  }

  /// The initial state of the bloc is always StateInitial
  @override
  BlocState get initialState => StateInitial();

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is InitializeEvent) {
      try {
        yield StateInitializing(0);
        yield* initialize();
        _initialized = true;
        yield StateInitialized();
        yield* onInitialized();
      } catch (e, stacktrace) {
        yield StateInitializationError('Initialization error', e, stacktrace);
      }
    } else if (_initialized) {
      assert(event is E);
      yield* eventToState(event as E);
    } else {
      throw Exception('Bloc is not initialized yet...');
    }
  }

  @override
  @deprecated
  /// This method is deprecated. Use the [event] method instead for adding
  /// events to the bloc
  void add(BlocEvent e) {
    throw Exception(
        "Using the add method is not allowed. Use the event() method instead");
  }

  /// Adds a new event to the stream
  /// Must be used instead of the add() method of the [Bloc] class
  void event(E event) {
    super.add(event);
  }

  /// Used for initializing the block.
  /// Can update progress by yielding StateInitializing.
  /// If you want to yield an error, then throw an exception.
  /// If an exception is thrown, then a [StateInitializationError] is yielded
  Stream<StateInitializing> initialize() async* {}

  /// Called when the bloc is initialized (when [StateInitialized] is yielded
  /// Can be used for adding some event or for yielding some state after
  /// initialization is done
  Stream<S> onInitialized() async* {}

  /// Must be implemented when a class extends [BaseBloc].
  /// Takes the incoming [event] as the argument.
  /// [eventToState] is called whenever an [event] is added.
  /// [eventToState] must convert that [event] into a new [state]
  /// and return the new [state] in the form of a `Stream<State>`.
  Stream<S> eventToState(E event);
}
