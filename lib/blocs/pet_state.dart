part of 'pet_cubit.dart';

abstract class PetState {}

class PetLoading extends PetState {}

class PetLoaded extends PetState {
  final List<Pet> pets;
  final bool hasFilters;
  final bool hasMoreData;

  PetLoaded(this.pets, {this.hasFilters = false, this.hasMoreData = true});
}

class PetLoadingMore extends PetState {
  final List<Pet> pets;
  final bool hasFilters;

  PetLoadingMore(this.pets, this.hasFilters);
}

class PetError extends PetState {
  final String message;
  PetError(this.message);
}
