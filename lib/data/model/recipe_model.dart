class RecipeModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String image;

  RecipeModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.image,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      image: json['strMealThumb'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "idMeal": id,
        "strMeal": name,
        "strCategory": category,
        "strArea": area,
        "strMealThumb": image,
      };
}
