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

class _MangaDetailPageState extends State<MangaDetailPage>
    with TickerProviderStateMixin {
  TabController? _outerTabController;
  TabController? _innerTabController;

  bool isChapterTabSelected = true;
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
  void dispose() {
    _innerTabController?.dispose();
    _outerTabController?.dispose();
    super.dispose();
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

  _updateInnerTabController() {
    if (_innerTabController == null ||
        _innerTabController!.length !=
            (isChapterTabSelected
                ? manga!.chapters.length
                : manga!.volumes.length)) {
      _innerTabController?.dispose();
      _innerTabController = TabController(
        length: isChapterTabSelected
            ? manga!.chapters.length
            : manga!.volumes.length,
        vsync: this,
      );
    }
    setState(() {});
  }

  TabController? _buildOuterTabController(DetailedManga manga) {
    if (manga.chapters.isNotEmpty && manga.volumes.isNotEmpty) {
      if (_outerTabController == null) {
        var tabControl = TabController(length: 2, vsync: this);
        tabControl.addListener(_updateInnerTabController);
        _outerTabController = tabControl;
      }
      _updateInnerTabController(); // Ensure inner controller is updated
      return _outerTabController;
    }
    _updateInnerTabController(); // Ensure inner controller is updated
    return null;
  }

  Future<void> _loadMangaDetails() async {
    try {
      final detailedManga = await service.fetchMangaDetails(widget.manga.code);
      setState(() {
        manga = detailedManga;
        _outerTabController = _buildOuterTabController(manga!);
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
      mainAxisSize: MainAxisSize.min,

      children: [
        AnimatedCrossFade(
          firstChild: Text(
            manga!.synopsis.isEmpty ? 'No detail!' : manga!.synopsis,
            maxLines: 3,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          secondChild: Text(
            manga!.synopsis.isEmpty ? 'No detail!' : manga!.synopsis,
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

  Widget _buildChaptersContent() {
    if (_innerTabController == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        // Tabs for selecting languages or other chapter groups
        TabBar(
          isScrollable: true,
          controller: _innerTabController,
          indicatorColor: Colors.orangeAccent,
          indicatorWeight: 3.0,
          labelColor: Colors.orangeAccent,
          unselectedLabelColor: Colors.white,
          tabAlignment: TabAlignment.start,
          // Aligns the TabBar to the left
          tabs: manga!.chapters.map((chapter) {
            return Tab(text: chapter.language);
          }).toList(),
        ),
        // Scrollable horizontal list of chapters
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: manga!.chapters.map((chapter) {
              return ListView.builder(
                itemCount: chapter.chapters.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      title: Text(chapter.chapters[index].name ?? 'Cap. $index',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          )),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Chapter selected!')),
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVolumesContent() {
    return Text('Volumes');
  }

  Widget buildChaptersAndVolumesTabs() {
    if (manga!.volumes.isNotEmpty && manga!.chapters.isNotEmpty) {
      return Expanded(
        child: Column(
          children: [
            TabBar(
              controller: _outerTabController,
              indicatorColor: Colors.orangeAccent,
              indicatorWeight: 3.0,
              labelColor: Colors.orangeAccent,
              unselectedLabelColor: Colors.white,
              tabs: const [
                Tab(text: "Capítulos"),
                Tab(text: "Volumes"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _outerTabController,
                children: [
                  _buildChaptersContent(),
                  _buildVolumesContent(),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (manga!.chapters.isNotEmpty) {
      return _buildChaptersContent();
    } else if (manga!.volumes.isNotEmpty) {
      return _buildVolumesContent();
    }
    return const Center(
      child: Text(
        "Sem capítulos ou volumes disponíveis",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget getDetailMangaWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
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
        const SizedBox(height: 16),
        // buildChaptersAndVolumesTabs(),
      ],
    );
  }

  Widget getLoadingMangaWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
      backgroundColor: Colors.black26,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeArea(
                child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context,
                          mustReload()); // Go back to the previous page
                    },
                  ),
                ],
              ),
            )),
            SingleChildScrollView(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
