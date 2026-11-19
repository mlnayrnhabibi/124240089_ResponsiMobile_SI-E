import 'package:flutter/material.dart';
import '../config.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../services/favorite_store.dart';
import '../widgets/recipe_image.dart';

class DetailPage extends StatefulWidget {
  final int recipeId;
  const DetailPage({super.key, required this.recipeId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Recipe? _recipe;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await ApiService.fetchDetail(widget.recipeId);
      if (!mounted) return;
      setState(() {
        _recipe = r;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat detail resep';
        _loading = false;
      });
    }
  }

  Future<void> _toggleFav() async {
    final r = _recipe;
    if (r == null) return;
    final added = await FavoriteStore.instance.toggle(r);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content:
            Text(added ? 'Ditambahkan ke favorite' : 'Dihapus dari favorite'),
        duration: const Duration(seconds: 2),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Resep'),
        actions: [
          ListenableBuilder(
            listenable: FavoriteStore.instance,
            builder: (_, __) {
              final fav = FavoriteStore.instance.isFavorite(widget.recipeId);
              return IconButton(
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                    color: fav ? Colors.yellow : Colors.white),
                onPressed: _recipe == null ? null : _toggleFav,
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      TextButton(
                          onPressed: _load, child: const Text('Coba lagi')),
                    ],
                  ),
                )
              : _buildContent(_recipe!),
    );
  }

  Widget _buildContent(Recipe r) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecipeImage(
              url: r.image,
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${r.cuisine} • ${r.mealType.join(', ')}',
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(Icons.star, '${r.rating} (${r.reviewCount})'),
                    _chip(Icons.speed, r.difficulty),
                    _chip(Icons.timer_outlined, 'Persiapan ${r.prepTime} mnt'),
                    _chip(Icons.soup_kitchen, 'Masak ${r.cookTime} mnt'),
                    _chip(Icons.people_outline, '${r.servings} porsi'),
                    _chip(Icons.bolt, '${r.calories} kal/porsi'),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Bahan-bahan',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                for (final ing in r.ingredients)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• $ing'),
                  ),
                const SizedBox(height: 20),
                const Text('Langkah Memasak',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                for (int i = 0; i < r.instructions.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 11,
                          backgroundColor: kGreen,
                          child: Text('${i + 1}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(r.instructions[i])),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 4),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );
}
