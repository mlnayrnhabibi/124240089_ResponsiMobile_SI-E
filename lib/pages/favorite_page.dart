import 'package:flutter/material.dart';
import '../config.dart';
import '../services/favorite_store.dart';
import '../widgets/recipe_image.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      body: ListenableBuilder(
        listenable: FavoriteStore.instance,
        builder: (context, _) {
          final items = FavoriteStore.instance.items;
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada resep favorite'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final r = items[i];
              return Card(
                color: kCard,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailPage(recipeId: r.id))),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                        width: 64,
                        height: 52,
                        child: RecipeImage(url: r.image)),
                  ),
                  title: Text(r.name),
                  subtitle: Text('${r.cuisine} • ${r.difficulty}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => FavoriteStore.instance.toggle(r),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
