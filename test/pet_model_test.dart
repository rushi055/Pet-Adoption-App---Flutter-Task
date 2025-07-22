import 'package:flutter_test/flutter_test.dart';
import 'package:pet_app/models/pet.dart';

void main() {
  group('Pet Model', () {
    final petJson = {
      'id': 1,
      'name': 'Bella',
      'type': 'Dog',
      'age': 2,
      'price': 120,
      'image': 'https://images.unsplash.com/photo-1558788353-f76d92427f16',
      'description': 'Friendly and playful golden retriever.',
      'isAdopted': false,
      'isFavorite': false,
    };

    test('fromJson creates correct Pet', () {
      final pet = Pet.fromJson(petJson);
      expect(pet.id, 1);
      expect(pet.name, 'Bella');
      expect(pet.type, 'Dog');
      expect(pet.age, 2);
      expect(pet.price, 120);
      expect(pet.image, isNotEmpty);
      expect(pet.description, isNotEmpty);
      expect(pet.isAdopted, false);
      expect(pet.isFavorite, false);
    });

    test('toJson returns correct map', () {
      final pet = Pet.fromJson(petJson);
      final json = pet.toJson();
      expect(json['id'], 1);
      expect(json['name'], 'Bella');
      expect(json['type'], 'Dog');
      expect(json['age'], 2);
      expect(json['price'], 120);
      expect(json['image'], isNotEmpty);
      expect(json['description'], isNotEmpty);
      expect(json['isAdopted'], false);
      expect(json['isFavorite'], false);
    });

    test('copyWith updates fields', () {
      final pet = Pet.fromJson(petJson);
      final adoptedPet = pet.copyWith(isAdopted: true);
      expect(adoptedPet.isAdopted, true);
      expect(adoptedPet.isFavorite, false);
      final favoritePet = pet.copyWith(isFavorite: true);
      expect(favoritePet.isFavorite, true);
      expect(favoritePet.isAdopted, false);
    });
  });
}
