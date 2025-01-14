import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangaart/models/manga_wrapper.dart';
import 'package:mangaart/pages/mangas_page.dart';
import 'package:mangaart/pages/utils/progress.dart';
import 'package:mangaart/services/manga_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MangaService service = MangaService();
  final TextEditingController _searchController = TextEditingController();
  bool isSearched = false;
  bool isLoading = false;
  MangaWrapper mangas = MangaWrapper([], false, null);
  Timer? _debounce; // Timer for debounce logic

  @override
  void initState() {
    super.initState();
    _setupSearchListener();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel any pending debounce timer
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _setupSearchListener() {
    String? previousValue;

    _searchController.addListener(() {
      final currentValue = _searchController.text;

      // Avoid redundant searches
      if (currentValue != previousValue) {
        previousValue = currentValue;

        // Cancel any ongoing debounce timer
        _debounce?.cancel();

        // Start a new debounce timer
        _debounce = Timer(const Duration(milliseconds: 500), () {
          // Trigger search only if the input is not empty
          if (currentValue.isNotEmpty) {
            _performSearch(currentValue);
          }
        });
      }
    });
  }

  // Perform the search
  Future<void> _performSearch(String query) async {
    setState(() {
      isLoading = true;
    });
    if (query.isEmpty) {
      setState(() {
        mangas = MangaWrapper([], true, "Nenhum resultado encontrado");
      });
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      mangas = MangaWrapper([], false, null);
    });

    try {
      final results = await service.fetchMangas(query);
      setState(() {
        mangas = MangaWrapper(results, true, null);
      });
    } catch (error) {
      setState(() {
        mangas = MangaWrapper([], true, error.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget getSearchResultsWidget() {
    if (isLoading) {
      return Progress.loading();
    }
    return Expanded(
        child: MangaPage.buildGrid(context: context, mangas: mangas));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Search Bar
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _searchController,
          enabled: !isLoading, // Disable when loading
          decoration: InputDecoration(
            hintText: 'Procure um  mangá ...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ),
      getSearchResultsWidget(),
    ]);
  }
}
