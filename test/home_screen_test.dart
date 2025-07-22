import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_app/blocs/pet_cubit.dart';
import 'package:pet_app/models/pet.dart';
import 'package:pet_app/screens/home_screen.dart';
import 'package:pet_app/data/pet_repository.dart';

class MockPetCubit extends PetCubit {
  MockPetCubit() : super(DummyPetRepository());
}

class DummyPetRepository extends PetRepository {
  @override
  Future<List<Pet>> fetchPets() async => [];
}

void main() {
  testWidgets('HomeScreen shows search bar and loading indicator', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PetCubit>(
          create: (_) => MockPetCubit(),
          child: HomeScreen(),
        ),
      ),
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HomeScreen shows pet list', (tester) async {
    final pets = [
      Pet(
        id: 1,
        name: 'Bella',
        type: 'Dog',
        age: 2,
        price: 120,
        image: 'https://images.unsplash.com/photo-1558788353-f76d92427f16',
        description: 'Friendly and playful golden retriever.',
      ),
      Pet(
        id: 2,
        name: 'Max',
        type: 'Dog',
        age: 3,
        price: 100,
        image: 'https://images.unsplash.com/photo-1518717758536-85ae29035b6d',
        description: 'Energetic beagle who loves walks.',
      ),
    ];
    final cubit = MockPetCubit();
    cubit.emit(PetLoaded(pets));
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PetCubit>.value(value: cubit, child: HomeScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('Bella'), findsOneWidget);
    expect(find.text('Max'), findsOneWidget);
  });
}
