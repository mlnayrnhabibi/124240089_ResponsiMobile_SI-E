import 'package:flutter/material.dart';

/// Gambar jaringan dengan loading indicator + exception handling
/// (ikon broken image jika gagal dimuat).
class RecipeImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const RecipeImage(
      {super.key,
      required this.url,
      this.fit = BoxFit.cover,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    Widget placeholder(IconData icon) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade300,
          child: Icon(icon, color: Colors.grey.shade600),
        );

    if (url.isEmpty) return placeholder(Icons.broken_image);

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => placeholder(Icons.broken_image),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: const Center(
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))),
        );
      },
    );
  }
}
