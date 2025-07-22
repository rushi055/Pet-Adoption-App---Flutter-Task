import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/pet.dart';
import '../data/pet_repository.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final PetRepository repository;
  List<Pet> _allPets = [];
  String _currentQuery = '';
  String _currentTypeFilter = '';
  String _currentAgeFilter = '';
  String _currentPriceFilter = '';

  // Pagination variables
  static const int _itemsPerPage = 10;
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  PetCubit(this.repository) : super(PetLoading()) {
    loadPets();
  }

  Future<void> loadPets({bool forceRefresh = false}) async {
    emit(PetLoading());
    try {
      _allPets = await repository.fetchPets(forceRefresh: forceRefresh);
      _currentPage = 1;
      _hasMoreData = true;
      _applyFiltersAndPagination();
    } catch (e) {
      emit(PetError('Failed to load pets'));
    }
  }

  void searchPets(String query) {
    _currentQuery = query;
    _currentPage = 1;
    _hasMoreData = true;
    _applyFiltersAndPagination();
  }

  void filterByType(String type) {
    _currentTypeFilter = type;
    _currentPage = 1;
    _hasMoreData = true;
    _applyFiltersAndPagination();
  }

  void filterByAge(String ageRange) {
    _currentAgeFilter = ageRange;
    _currentPage = 1;
    _hasMoreData = true;
    _applyFiltersAndPagination();
  }

  void filterByPrice(String priceRange) {
    _currentPriceFilter = priceRange;
    _currentPage = 1;
    _hasMoreData = true;
    _applyFiltersAndPagination();
  }

  void clearFilters() {
    _currentQuery = '';
    _currentTypeFilter = '';
    _currentAgeFilter = '';
    _currentPriceFilter = '';
    _currentPage = 1;
    _hasMoreData = true;
    _applyFiltersAndPagination();
  }

  Future<void> loadMorePets() async {
    if (!_hasMoreData || _isLoadingMore) return;

    _isLoadingMore = true;
    final currentState = state;

    if (currentState is PetLoaded) {
      emit(PetLoadingMore(currentState.pets, currentState.hasFilters));

      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      _currentPage++;
      _applyFiltersAndPagination();
    }

    _isLoadingMore = false;
  }

  void _applyFiltersAndPagination() {
    List<Pet> filteredPets = List.from(_allPets);

    // Apply search filter
    if (_currentQuery.isNotEmpty) {
      filteredPets = filteredPets
          .where((pet) => pet.name.toLowerCase().contains(_currentQuery.toLowerCase()))
          .toList();
    }

    // Apply type filter
    if (_currentTypeFilter.isNotEmpty && _currentTypeFilter != 'All') {
      filteredPets = filteredPets
          .where((pet) => pet.type.toLowerCase() == _currentTypeFilter.toLowerCase())
          .toList();
    }

    // Apply age filter
    if (_currentAgeFilter.isNotEmpty && _currentAgeFilter != 'All') {
      filteredPets = filteredPets.where((pet) {
        switch (_currentAgeFilter) {
          case 'Young (0-2 years)':
            return pet.age <= 2;
          case 'Adult (3-7 years)':
            return pet.age >= 3 && pet.age <= 7;
          case 'Senior (8+ years)':
            return pet.age >= 8;
          default:
            return true;
        }
      }).toList();
    }

    // Apply price filter
    if (_currentPriceFilter.isNotEmpty && _currentPriceFilter != 'All') {
      filteredPets = filteredPets.where((pet) {
        switch (_currentPriceFilter) {
          case 'Low (₹0-₹10,000)':
            return pet.price <= 10000;
          case 'Medium (₹10,001-₹25,000)':
            return pet.price > 10000 && pet.price <= 25000;
          case 'High (₹25,000+)':
            return pet.price > 25000;
          default:
            return true;
        }
      }).toList();
    }

    // Apply pagination
    final totalItems = filteredPets.length;
    final endIndex = _currentPage * _itemsPerPage;
    final paginatedPets = filteredPets.take(endIndex).toList();

    _hasMoreData = endIndex < totalItems;

    final hasFilters = _currentQuery.isNotEmpty ||
                      _currentTypeFilter.isNotEmpty ||
                      _currentAgeFilter.isNotEmpty ||
                      _currentPriceFilter.isNotEmpty;

    emit(PetLoaded(paginatedPets, hasFilters: hasFilters, hasMoreData: _hasMoreData));
  }

  // Get available filter options
  List<String> get availableTypes {
    final types = _allPets.map((pet) => pet.type).toSet().toList();
    types.sort();
    return ['All', ...types];
  }

  List<String> get availableAgeRanges {
    return ['All', 'Young (0-2 years)', 'Adult (3-7 years)', 'Senior (8+ years)'];
  }

  List<String> get availablePriceRanges {
    return ['All', 'Low (₹0-₹10,000)', 'Medium (₹10,001-₹25,000)', 'High (₹25,000+)'];
  }

  // Existing methods remain the same
  Future<void> adoptPet(Pet pet) async {
    await repository.adoptPet(pet.id);
    await loadPets();
  }

  Future<void> favoritePet(Pet pet) async {
    await repository.favoritePet(pet.id);
    await loadPets();
  }

  Future<void> unfavoritePet(Pet pet) async {
    await repository.unfavoritePet(pet.id);
    await loadPets();
  }

  Future<void> refreshPets() async {
    await repository.clearCache();
    await loadPets(forceRefresh: true);
  }
}
