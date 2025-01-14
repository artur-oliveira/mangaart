import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangaart/models/manga_wrapper.dart';

import '../models/manga.dart';
import 'manga_card.dart';
import 'manga_detail.dart';

class MangaPage {
  static GestureTapCallback buildOnTap(BuildContext context, Manga manga) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MangaDetailPage(manga: manga),
        ),
      );
    };
  }

  static Widget buildGrid(
      {required BuildContext context,
      required MangaWrapper mangas,
      Function(void)? onUnFav,
      int crossAxisCount = 3, // Default number of columns
      double spacing = 8.0, // Default spacing
      double childAspectRatio = 0.7, // Default size ratio
      Function? onTap}) {
    if (mangas.mangas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(CupertinoIcons.info_circle,
                size: 48, color: CupertinoColors.systemGrey),
            SizedBox(height: 8),
            Text(
              'Nada por aqui!',
              style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
            ),
          ],
        ),
      );
    }
    onTap ??= buildOnTap;
    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: mangas.mangas.length,
      itemBuilder: (context, index) {
        final manga = mangas.mangas[index];
        return GestureDetector(
          onTap: onTap!(context, manga),
          child: MangaCard(manga: manga),
        );
      },
    );
  }
}
