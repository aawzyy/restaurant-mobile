import 'dart:io';
import '../repositories/menu_repository.dart';

class UpdateMenuUseCase {
  final MenuRepository repository;

  UpdateMenuUseCase(this.repository);

  Future<void> execute({
    required int id,
    required String name,
    required String description,
    required double price,
    required int categoryId,
    File? imageFile,
  }) {
    return repository.updateMenu(
      id: id,
      name: name,
      description: description,
      price: price,
      categoryId: categoryId,
      imageFile: imageFile,
    );
  }
}
