import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mangaart/constants.dart';
import 'package:mangaart/models/detailed_manga.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/manga.dart';

class MangaService {
  // Singleton instance
  static final MangaService _instance = MangaService._internal();
  static final String _favoritesKey = 'mangas_art:favorites';

  // Dio client
  final Dio _dio;

  // Private constructor
  MangaService._internal()
      : _dio = Dio(BaseOptions(
            baseUrl: Constants.apiHost,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30)));

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
  Future<DetailedManga> fetchMangaDetails(String mangaCode) async {
    try {
      final response = await _dio.get('/v1/mangas/$mangaCode');
      return DetailedManga.fromJson(response.data);
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
    final jsonString = (await SharedPreferences.getInstance()).getString(_favoritesKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((el) => Manga.fromJson(el)).toList();
  }

  Future<void> addFavorite(Manga manga) async {
    final favorites = await getFavorites();
    favorites.add(manga);
    await saveFavorites(favorites);
  }

  Future<void> saveFavorites(List<Manga> favorites) async {
    final jsonString = jsonEncode(favorites);
    await (await SharedPreferences.getInstance()).setString(_favoritesKey, jsonString);
  }

  Future<void> removeFavorite(Manga manga) {
    return getFavorites().then((favorites) {
      favorites.removeWhere((element) => element.code == manga.code);
      return saveFavorites(favorites);
    });
  }
}
