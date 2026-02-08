import '../entities/menu_entity.dart';
import '../repositories/menu_repository.dart';

class GetMenusUseCase {
  final MenuRepository repository;
  GetMenusUseCase(this.repository);

  Future<List<MenuEntity>> execute() {
    return repository.getMenus();
  }
}
