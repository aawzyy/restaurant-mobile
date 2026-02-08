import 'dart:io';
import '../repositories/menu_repository.dart';

class CreateMenuUseCase {
  final MenuRepository repository;

  CreateMenuUseCase(this.repository);

  Future<void> execute({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    File? imageFile,
  }) {
    // Pastikan memanggil dengan nama parameter (name: name, dst)
    return repository.createMenu(
      name: name,
      description: description,
      price: price,
      categoryId: categoryId,
      imageFile: imageFile,
    );
  }
}
