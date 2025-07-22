part of 'history_cubit.dart';

abstract class HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Pet> pets;
  HistoryLoaded(this.pets);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}
