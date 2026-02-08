import '../repositories/order_repository.dart';

class SubmitOrderUseCase {
  final OrderRepository repository;
  SubmitOrderUseCase(this.repository);

  Future<bool> execute(int tableId, List<Map<String, dynamic>> items) {
    return repository.submitOrder(tableId: tableId, items: items);
  }
}
