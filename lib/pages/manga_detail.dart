import 'package:flutter/material.dart';
import 'package:mangaart/models/manga.dart';

class MangaDetailPage extends StatefulWidget {
  final Manga manga;

  const MangaDetailPage({super.key, required this.manga});

  @override
  State<MangaDetailPage> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Text('kek');
  }
}
