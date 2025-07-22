import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/pet_repository.dart';
import 'blocs/pet_cubit.dart';
import 'blocs/history_cubit.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/history_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PetRepository.initHive();
  runApp(const PetApp());
}

class PetApp extends StatelessWidget {
  const PetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petRepository = PetRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PetCubit(petRepository)),
        BlocProvider(create: (_) => HistoryCubit(petRepository)),
      ],
      child: MaterialApp(
        title: 'Pet Adoption App',
        theme: AppTheme.lightTheme,
        //darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = [
    HomeScreen(),
    FavoritesScreen(),
    HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
