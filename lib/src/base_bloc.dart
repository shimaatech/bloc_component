import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

/// Bloc base state
/// All states must inherit from [BlocState]
abstract class BlocState implements Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class StateLoading extends BlocState {
  final double progress;

  StateLoading([this.progress]);

  @override
  List<Object> get props => [progress];
}

class StateInitial extends BlocState {}


class StateError extends BlocState {
  final String message;
  final dynamic exception;
  final StackTrace stackTrace;

  StateError(this.message, [this.exception, this.stackTrace]);

  @override
  List<Object> get props => [message, exception];

  @override
  String toString() {
    return "Error: $message";
  }
}

/// Bloc base event
/// All events must inherit from [BlocEvent]
abstract class BlocEvent implements Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}


abstract class BaseBloc extends Bloc<BlocEvent, BlocState> {

  @override
  BlocState get initialState => StateInitial();

}
