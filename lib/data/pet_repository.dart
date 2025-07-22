import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/pet.dart';

class PetRepository {
  static const String adoptedKey = 'adopted_pets';
  static const String favoriteKey = 'favorite_pets';
  static const String petsBoxName = 'petsBox';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(petsBoxName)) {
      await Hive.openBox(petsBoxName);
    }
  }

  Future<List<Pet>> fetchPets({bool forceRefresh = false}) async {
    final box = Hive.box(petsBoxName);
    List<dynamic>? cached = box.get('pets');
    if (cached != null && !forceRefresh) {
      final adoptedIds = await _getAdoptedPetIds();
      final favoriteIds = await _getFavoritePetIds();
      return (cached as List)
          .map((json) => Pet.fromJson(Map<String, dynamic>.from(json)))
          .map(
            (pet) => pet.copyWith(
              isAdopted: adoptedIds.contains(pet.id),
              isFavorite: favoriteIds.contains(pet.id),
            ),
          )
          .toList();
    }
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    final String response = await rootBundle.loadString('assets/pets.json');
    final List<dynamic> data = json.decode(response);
    await box.put('pets', data);
    final adoptedIds = await _getAdoptedPetIds();
    final favoriteIds = await _getFavoritePetIds();
    return data
        .map((json) => Pet.fromJson(json))
        .map(
          (pet) => pet.copyWith(
            isAdopted: adoptedIds.contains(pet.id),
            isFavorite: favoriteIds.contains(pet.id),
          ),
        )
        .toList();
  }

  Future<void> clearCache() async {
    final box = Hive.box(petsBoxName);
    await box.delete('pets');
  }

  Future<void> adoptPet(int petId) async {
    final prefs = await SharedPreferences.getInstance();
    final adopted = prefs.getStringList(adoptedKey) ?? [];
    if (!adopted.contains(petId.toString())) {
      adopted.add(petId.toString());
      await prefs.setStringList(adoptedKey, adopted);
    }
  }

  Future<void> favoritePet(int petId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(favoriteKey) ?? [];
    if (!favorites.contains(petId.toString())) {
      favorites.add(petId.toString());
      await prefs.setStringList(favoriteKey, favorites);
    }
  }

  Future<void> unfavoritePet(int petId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(favoriteKey) ?? [];
    favorites.remove(petId.toString());
    await prefs.setStringList(favoriteKey, favorites);
  }

  Future<List<int>> _getAdoptedPetIds() async {
    final prefs = await SharedPreferences.getInstance();
    final adopted = prefs.getStringList(adoptedKey) ?? [];
    return adopted.map(int.parse).toList();
  }

  Future<List<int>> _getFavoritePetIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(favoriteKey) ?? [];
    return favorites.map(int.parse).toList();
  }

  Future<List<Pet>> fetchAdoptedPets() async {
    final pets = await fetchPets();
    return pets.where((pet) => pet.isAdopted).toList();
  }

  Future<List<Pet>> fetchFavoritePets() async {
    final pets = await fetchPets();
    return pets.where((pet) => pet.isFavorite).toList();
  }
}
