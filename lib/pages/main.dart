import 'package:flutter/material.dart';
import 'package:mangaart/pages/most_viewed.dart';
import 'package:mangaart/pages/search.dart';
import 'package:mangaart/pages/top_trending.dart';

import 'favorites.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of Screens for Each Tab
  final List<Widget> _screens = [
    const FavoritesScreen(),
    const TopTrendingScreen(),
    const MostViewedScreen(),
    const SearchScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      backgroundColor: Colors.blueGrey[800],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.blueGrey[900],
        // Custom background color
        selectedItemColor: Colors.orangeAccent,
        // Color for the selected tab
        unselectedItemColor: Colors.white,
        // Color for unselected tabs
        type: BottomNavigationBarType.fixed,
        // Fixed spacing
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Tendências',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Mais Lidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pesquisar',
          ),
        ],
      ),
    );
  }
}
