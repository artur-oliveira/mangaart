import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangaart/models/detailed_manga.dart';
import 'package:mangaart/models/manga.dart';
import 'package:mangaart/services/manga_service.dart';

class MangaDetailPage extends StatefulWidget {
  final Manga manga;

  const MangaDetailPage({super.key, required this.manga});

  @override
  State<MangaDetailPage> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  DetailedManga? manga;
  String? error;
  bool? favoritedInitialState;
  bool isExpanded = false;
  bool isFavorited = false;
  bool isLoadingFavorited = false;
  MangaService service = MangaService();

  @override
  void initState() {
    super.initState();
    _loadMangaDetails();
    _loadFavorite();
  }

  @override
  @protected
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _loadFavorite() async {
    setState(() {
      isLoadingFavorited = true;
    });
    try {
      final favorites = await service.getFavorites();
      bool foundFavorite =
          favorites.map((e) => e.code).contains(widget.manga.code);

      if (favoritedInitialState == null) {
        setState(() {
          favoritedInitialState = foundFavorite;
        });
      }

      setState(() {
        isFavorited = foundFavorite;
      });
    } finally {
      setState(() {
        isLoadingFavorited = false;
      });
    }
  }

  Future<void> _loadMangaDetails() async {
    try {
      final detailedManga = await service.fetchMangaDetails(widget.manga.code);
      setState(() {
        manga = detailedManga;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      // Handle error
    }
  }

  Future<void> toggleFavorite() async {
    setState(() {
      isLoadingFavorited = true;
    });

    try {
      if (isFavorited) {
        await service.removeFavorite(widget.manga);
        setState(() {
          isFavorited = false;
        });
      } else {
        await service.addFavorite(widget.manga);
        setState(() {
          isFavorited = true;
        });
      }
    } finally {
      setState(() {
        isLoadingFavorited = false;
      });
    }
  }

  Widget buildMangaText(String text) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildPosterWidget(String cover) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      child: CachedNetworkImage(
        imageUrl: cover,
        fit: BoxFit.cover,
        width: 100,
        height: 150,
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget buildSynopsis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            manga!.synopsis,
            maxLines: 3,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          secondChild: Text(
            manga!.synopsis,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 28,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget getRowButtonsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            IconButton(
              icon: isLoadingFavorited
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    )
                  : Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      size: 28,
                      color: Colors.grey,
                    ),
              onPressed: isLoadingFavorited
                  ? null
                  : () {
                      toggleFavorite();
                    },
            ),
            Text(isFavorited ? 'Remover' : 'Adicionar',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.share, size: 28, color: Colors.grey),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share button pressed!')),
                );
              },
            ),
            const Text('Compartilhar',
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ],
        )
      ],
    );
  }

  Widget getDetailMangaWidget() {
    return Center(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildPosterWidget(manga!.poster),
              const SizedBox(width: 16),
              buildMangaText(manga!.name),
            ],
          ),
          const SizedBox(height: 16),
          getRowButtonsWidget(),
          const SizedBox(height: 16),
          // Loading Indicator
          buildSynopsis(),
        ],
      ),
    );
  }

  Widget getLoadingMangaWidget() {
    return Center(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildPosterWidget(widget.manga.poster),
              const SizedBox(width: 16),
              buildMangaText(widget.manga.name),
            ],
          ),
          const SizedBox(height: 16),
          getRowButtonsWidget(),
          const SizedBox(height: 16), // Loading Indicator
          const CircularProgressIndicator()
        ],
      ),
    );
  }

  bool mustReload() {
    if (favoritedInitialState == null) {
      return false;
    }
    return favoritedInitialState != isFavorited;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (manga == null) {
      child = getLoadingMangaWidget();
    } else {
      child = getDetailMangaWidget();
    }
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(
                        context, mustReload()); // Go back to the previous page
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
        ],
      )),
    );
  }
}
