import 'dart:convert';

class Pet {
  final int id;
  final String name;
  final String type;
  final int age;
  final int price;
  final String image;
  final String description;
  bool isAdopted;
  bool isFavorite;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.price,
    required this.image,
    required this.description,
    this.isAdopted = false,
    this.isFavorite = false,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      age: json['age'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
      isAdopted: json['isAdopted'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'age': age,
      'price': price,
      'image': image,
      'description': description,
      'isAdopted': isAdopted,
      'isFavorite': isFavorite,
    };
  }

  Pet copyWith({bool? isAdopted, bool? isFavorite}) {
    return Pet(
      id: id,
      name: name,
      type: type,
      age: age,
      price: price,
      image: image,
      description: description,
      isAdopted: isAdopted ?? this.isAdopted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
