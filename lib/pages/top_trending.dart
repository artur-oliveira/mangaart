import 'package:flutter/material.dart';
import 'package:mangaart/pages/utils/progress.dart';

import '../models/manga_wrapper.dart';
import '../services/manga_service.dart';
import 'mangas_page.dart';

class TopTrendingScreen extends StatefulWidget {
  const TopTrendingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TopTrendingScreenState();
  }
}

class _TopTrendingScreenState extends State<TopTrendingScreen> {
  MangaWrapper mangas = MangaWrapper([], false, null);

  @override
  void initState() {
    super.initState();
    fetchTrendingMangas();
  }

  @override
  @protected
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> fetchTrendingMangas() async {
    try {
      final topTrending = await MangaService().fetchTopTrending();
      setState(() {
        mangas = MangaWrapper(topTrending, true, null);
      });
    } catch (e) {
      setState(() {
        mangas = MangaWrapper([], true, e.toString());
      });
      // Handle error
    }
  }

  Widget getTopTrendingWidget() {
    if (!mangas.isLoaded) {
      return Progress.loading();
    }
    return MangaPage.buildGrid(context: context, mangas: mangas);
  }

  @override
  Widget build(BuildContext context) {
    return getTopTrendingWidget();
  }
}
