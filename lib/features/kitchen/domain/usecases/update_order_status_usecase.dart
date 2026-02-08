import '../repositories/kitchen_repository.dart';

class UpdateOrderStatusUseCase {
  final KitchenRepository repository;
  UpdateOrderStatusUseCase(this.repository);

  Future<void> execute(int orderId, String status) {
    return repository.updateOrderStatus(orderId, status);
  }
}
