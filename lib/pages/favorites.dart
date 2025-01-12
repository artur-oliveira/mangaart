import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangaart/models/manga_wrapper.dart';
import 'package:mangaart/services/manga_service.dart';

import 'mangas_page.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  MangaService service = MangaService();
  MangaWrapper mangas = MangaWrapper([], false, null);

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  @protected
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await service.getFavorites();
      setState(() {
        mangas = MangaWrapper(favorites, true, null);
      });
    } catch (e) {
      setState(() {
        mangas = MangaWrapper([], true, e.toString());
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!mangas.isLoaded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [CircularProgressIndicator()],
        ),
      );
    }

    if (mangas.mangas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tudo limpo por aqui!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return MangaPage.buildGrid(context: context, mangas: mangas);
  }
}
