import '../../../order/domain/entities/order_entity.dart';
import '../../domain/repositories/kitchen_repository.dart';
import '../datasources/kitchen_remote_data_source.dart';

class KitchenRepositoryImpl implements KitchenRepository {
  final KitchenRemoteDataSource remoteDataSource;

  KitchenRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<OrderEntity>> getKitchenOrders() async {
    // Model otomatis dianggap Entity (karena extends)
    return await remoteDataSource.fetchKitchenOrders();
  }

  @override
  Future<void> updateOrderStatus(int orderId, String status) async {
    await remoteDataSource.updateStatus(orderId, status);
  }
}
