import 'manga.dart';

class MangaWrapper {
  final List<Manga> mangas;
  bool isLoaded = false;
  String? error;

  MangaWrapper(this.mangas, this.isLoaded, this.error);
}
