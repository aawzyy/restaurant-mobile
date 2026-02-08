import '../entities/table_entity.dart';
import '../repositories/table_repository.dart';

class GetTablesUseCase {
  final TableRepository repository;

  GetTablesUseCase(this.repository);

  Future<List<TableEntity>> execute() {
    return repository.getTables();
  }
}
