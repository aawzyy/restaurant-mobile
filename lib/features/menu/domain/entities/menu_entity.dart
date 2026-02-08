class CategoryEntity {
  final int id;
  final String name;

  CategoryEntity({required this.id, required this.name});
}

class MenuEntity {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl; // URL dari MinIO
  final CategoryEntity category;

  MenuEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}
