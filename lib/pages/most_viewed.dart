import 'package:flutter/material.dart';
import 'package:mangaart/pages/utils/progress.dart';
import 'package:mangaart/services/manga_service.dart';

import '../models/manga_wrapper.dart';
import 'mangas_page.dart';

class MostViewedScreen extends StatefulWidget {
  const MostViewedScreen({super.key});

  @override
  State<MostViewedScreen> createState() => _MostViewedScreenState();
}

class _MostViewedScreenState extends State<MostViewedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.orangeAccent,
          // Underline color for the selected tab
          indicatorWeight: 3.0,
          // Thickness of the underline
          labelColor: Colors.orangeAccent,
          // Color of selected tab label
          unselectedLabelColor: Colors.white,
          // Color of unselected tab labels
          tabs: const [
            Tab(text: 'Dia'),
            Tab(text: 'Semana'),
            Tab(text: 'Mês'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              MostViewedContent(viewType: 'day'),
              MostViewedContent(viewType: 'week'),
              MostViewedContent(viewType: 'month'),
            ],
          ),
        ),
      ],
    );
  }
}

class MostViewedContent extends StatefulWidget {
  final String viewType;

  const MostViewedContent({required this.viewType, super.key});

  @override
  State<MostViewedContent> createState() => _MostViewedContentState();
}

class _MostViewedContentState extends State<MostViewedContent> {
  MangaService service = MangaService();
  MangaWrapper mangas = MangaWrapper([], false, null);

  @override
  void initState() {
    super.initState();
    fetchMostViewedMangas();
  }

  @override
  @protected
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> fetchMostViewedMangas() async {
    try {
      final mostViewed = await service.fetchMostViewed(widget.viewType);
      setState(() => mangas = MangaWrapper(mostViewed, true, null));
    } catch (e) {
      // Handle error (e.g., log it, show a message)
      debugPrint('Error fetching most viewed mangas: $e');
      setState(() => mangas = MangaWrapper([], true, e.toString()));
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    if (!mangas.isLoaded) {
      return Progress.loading();
    }
    return MangaPage.buildGrid(context: context, mangas: mangas);
  }
}
