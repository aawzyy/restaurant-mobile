import '../repositories/menu_repository.dart';

class DeleteMenuUseCase {
  final MenuRepository repository;

  DeleteMenuUseCase(this.repository);

  Future<void> execute(int id) {
    return repository.deleteMenu(id);
  }
}
