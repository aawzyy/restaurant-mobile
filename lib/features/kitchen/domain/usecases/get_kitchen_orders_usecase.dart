import '../../../order/domain/entities/order_entity.dart';
import '../repositories/kitchen_repository.dart';

class GetKitchenOrdersUseCase {
  final KitchenRepository repository;
  GetKitchenOrdersUseCase(this.repository);

  Future<List<OrderEntity>> execute() {
    return repository.getKitchenOrders();
  }
}
