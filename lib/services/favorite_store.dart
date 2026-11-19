import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

/// Single source of truth untuk favorite. Halaman favorite & detail
/// sama-sama mendengarkan ChangeNotifier ini, jadi selalu sinkron.
class FavoriteStore extends ChangeNotifier {
  FavoriteStore._();
  static final FavoriteStore instance = FavoriteStore._();
  static const _key = 'favorites';

  List<Recipe> _items = [];
  List<Recipe> get items => List.unmodifiable(_items);

  bool isFavorite(int id) => _items.any((r) => r.id == id);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _items = raw
        .map((s) => Recipe.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  /// return true jika ditambahkan, false jika dihapus
  Future<bool> toggle(Recipe r) async {
    final added = !isFavorite(r.id);
    if (added) {
      _items.add(r);
    } else {
      _items.removeWhere((e) => e.id == r.id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _key, _items.map((e) => jsonEncode(e.toJson())).toList());
    return added;
  }
}
