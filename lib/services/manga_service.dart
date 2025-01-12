import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mangaart/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/manga.dart';

class MangaService {
  // Singleton instance
  static final MangaService _instance = MangaService._internal();
  static final String _favoritesKey = 'mangas_art:favorites';

  // Dio client
  final Dio _dio;
  late final SharedPreferences _prefs;

  // Private constructor
  MangaService._internal()
      : _dio = Dio(BaseOptions(
            baseUrl: Constants.apiHost,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30))) {
    SharedPreferences.getInstance().then((prefs) => {
          _prefs = prefs,
        });
  }

  // Factory constructor to return the singleton instance
  factory MangaService() {
    return _instance;
  }

  // Fetch trending mangas
  Future<List<Manga>> fetchMangas(String query) async {
    try {
      final response = await _dio.get('/v1/mangas', queryParameters: {
        'query': query,
      });
      final List<dynamic> data = response.data;
      return data.map((e) => Manga.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load trending mangas: $e');
    }
  }

  // Fetch trending mangas
  Future<List<Manga>> fetchTopTrending() async {
    try {
      final response = await _dio.get('/v1/mangas/top-trending');
      final List<dynamic> data = response.data;
      return data.map((e) => Manga.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load trending mangas: $e');
    }
  }

  // Fetch manga details
  Future<Manga> fetchMangaDetails(String mangaCode) async {
    try {
      final response = await _dio.get('/v1/mangas/$mangaCode');
      return Manga.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load manga details: $e');
    }
  }

  // Fetch most viewed mangas
  Future<List<Manga>> fetchMostViewed(String viewType) async {
    try {
      final response = await _dio.get('/v1/mangas/most-viewed/$viewType');
      final List<dynamic> data = response.data;
      return data.map((e) => Manga.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load most viewed mangas: $e');
    }
  }

  Future<List<Manga>> getFavorites() async {
    final jsonString = _prefs.getString(_favoritesKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast();
  }

  Future<void> addFavorite(Manga manga) async {
    final favorites = await getFavorites();
    favorites.add(manga);
    await saveFavorites(favorites);
  }

  Future<void> saveFavorites(List<Manga> favorites) async {
    final jsonString = jsonEncode(favorites);
    await _prefs.setString(_favoritesKey, jsonString);
  }
}
