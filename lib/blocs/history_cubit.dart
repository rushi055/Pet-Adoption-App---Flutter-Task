import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/pet.dart';
import '../data/pet_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final PetRepository repository;

  HistoryCubit(this.repository) : super(HistoryLoading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    try {
      final pets = await repository.fetchAdoptedPets();
      emit(HistoryLoaded(pets));
    } catch (e) {
      emit(HistoryError('Failed to load history'));
    }
  }
}
