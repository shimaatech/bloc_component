import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

/// Bloc base state
/// All states must inherit from [BlocState]
abstract class BlocState implements Equatable {
  @override
  List<Object> get props => [];
}

/// The initial state of any bloc that extends [BaseBloc]
/// When the initial state is StateUninitialized, then the first event that
/// will be dispatched is the [InitializeEvent] which will call
/// [BaseBloc.initialize]
class StateUninitialized extends BlocState {}

/// Loading state. Used when the bloc is performing some action...
class StateLoading extends BlocState {
  final double progress;

  StateLoading([this.progress]);

  @override
  List<Object> get props => [progress];
}

/// A state that indicates that the bloc is being initialized. Allows reporting
/// [progress] of initializing
/// This state is implemented with [StateLoading] so that it can be used as
/// a loading state with the [StateBuilder]
class StateInitializing extends StateLoading {
  StateInitializing([double progress]) : super(progress);
}

/// Bloc error state
/// Each state that needs tto allow error functionality to be used with the
/// [StateBuilder[ must be implemented with [StateError]
class StateError extends BlocState {
  final String message;
  final dynamic exception;
  final StackTrace stackTrace;

  StateError(this.message, [this.exception, this.stackTrace]);

  @override
  List<Object> get props => [message, exception];
}

class StateInitializationError extends StateError {
  StateInitializationError(String message,
      [dynamic exception, StackTrace stackTrace])
      : super(message, exception, stackTrace);
}

/// A state that indicates that the bloc is initialized
class StateInitialized extends BlocState {}

/// Bloc base event
/// All events must inherit from [BlocEvent]
abstract class BlocEvent implements Equatable {
  @override
  List<Object> get props => [];
}

/// An event for initializing the blocs that inherit from [BaseBloc]
/// This event is dispatched when the bloc is created
class InitializeEvent extends BlocEvent {}

/// A base bloc that extends the Bloc class for providing additional
/// functionality. When the bloc is created, and [InitializeEvent] is dispatched.
/// In order to do some initializations, you can override the [initialize] method
/// If you need to yield some state upon initialization, then you can use the
/// [onInitialized] method
abstract class BaseBloc extends Bloc<BlocEvent, BlocState> {
  bool _initialized = false;

  BaseBloc() {
    if (initialState is StateUninitialized) {
      super.add(InitializeEvent());
    } else {
      // if the initial state is not StateInitial, then the bloc will be
      // initialized directly without calling the initialize() method.
      _initialized = true;
    }
  }

  /// The default initial state of the bloc is [StateUninitialized]
  /// If you override [initialState] to some other state rather than
  /// [StateUninitialized], then [InitializeEvent] won't be dispatched, and the
  /// [initialize] method won't be called
  @override
  BlocState get initialState => StateUninitialized();

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
        yield StateError('Initialization error', e, stacktrace);
      }
    } else if (_initialized) {
      yield* eventToState(event);
    } else {
      throw Exception('Bloc is not initialized yet...');
    }
  }

  /// Used for initializing the block.
  /// Can update progress by yielding StateInitializing.
  /// If you want to yield an error, then throw an exception.
  /// If an exception is thrown, then a [StateError] is yielded
  Stream<StateInitializing> initialize() async* {}

  /// Called when the bloc is initialized (when [StateInitialized] is yielded
  /// Can be used for adding some event or for yielding some state after
  /// initialization is done
  Stream<BlocState> onInitialized() async* {}

  /// Must be implemented when a class extends [BaseBloc].
  /// Takes the incoming [event] as the argument.
  /// [eventToState] is called whenever an [event] is added.
  /// [eventToState] must convert that [event] into a new [state]
  /// and return the new [state] in the form of a `Stream<State>`.
  Stream<BlocState> eventToState(BlocEvent event);
}
