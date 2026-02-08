import '../entities/menu_entity.dart';
import '../repositories/menu_repository.dart';

class GetCategoriesUseCase {
  final MenuRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> execute() {
    return repository.getCategories();
  }
}
