import '../../domain/entities/table_entity.dart';
import '../../domain/repositories/table_repository.dart';
import '../datasources/table_remote_data_source.dart';

class TableRepositoryImpl implements TableRepository {
  final TableRemoteDataSource remoteDataSource;

  TableRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TableEntity>> getTables() async {
    return await remoteDataSource.fetchTables();
  }
}
