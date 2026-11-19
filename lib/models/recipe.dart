class Recipe {
  final int id;
  final String name;
  final String image;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final String difficulty;
  final int prepTime;
  final int cookTime;
  final int servings;
  final int calories;
  final List<String> mealType;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.difficulty,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.calories,
    required this.mealType,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
        id: j['id'] ?? 0,
        name: j['name'] ?? '-',
        image: j['image'] ?? '',
        cuisine: j['cuisine'] ?? '-',
        rating: (j['rating'] ?? 0).toDouble(),
        reviewCount: j['reviewCount'] ?? 0,
        difficulty: j['difficulty'] ?? '-',
        prepTime: j['prepTimeMinutes'] ?? 0,
        cookTime: j['cookTimeMinutes'] ?? 0,
        servings: j['servings'] ?? 0,
        calories: j['caloriesPerServing'] ?? 0,
        mealType: List<String>.from(j['mealType'] ?? []),
        ingredients: List<String>.from(j['ingredients'] ?? []),
        instructions: List<String>.from(j['instructions'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'cuisine': cuisine,
        'rating': rating,
        'reviewCount': reviewCount,
        'difficulty': difficulty,
        'prepTimeMinutes': prepTime,
        'cookTimeMinutes': cookTime,
        'servings': servings,
        'caloriesPerServing': calories,
        'mealType': mealType,
        'ingredients': ingredients,
        'instructions': instructions,
      };
}
