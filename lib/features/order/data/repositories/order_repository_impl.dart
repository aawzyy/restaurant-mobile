import '../../../table/domain/entities/table_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TableEntity>> getTables() async {
    return await remoteDataSource.fetchTables();
  }

  @override
  Future<bool> submitOrder({
    required int tableId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final data = {"table_id": tableId, "items": items};
      return await remoteDataSource.postOrder(data);
    } catch (e) {
      throw Exception("Gagal kirim order: $e");
    }
  }
}
