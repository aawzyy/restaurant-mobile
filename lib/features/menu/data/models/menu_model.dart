import '../../domain/entities/menu_entity.dart';

class MenuModel extends MenuEntity {
  MenuModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Tanpa Nama',
      // Jika API Contract tidak kirim description, default ke string kosong
      description: json['description']?.toString() ?? '',
      // Safe parsing untuk price (bisa int atau double dari JSON)
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      // Menggunakan key 'image_url' sesuai API Contract
      imageUrl: json['image_url'] ?? '',
      category: CategoryModel.fromJson(json['category'] ?? {}),
    );
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'] ?? 0, name: json['name'] ?? 'Umum');
  }
}
