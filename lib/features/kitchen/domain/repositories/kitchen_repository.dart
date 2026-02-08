// Kita REUSE (Gunakan Kembali) Entity dari fitur Order biar hemat code
import '../../../order/domain/entities/order_entity.dart';

abstract class KitchenRepository {
  Future<List<OrderEntity>> getKitchenOrders();
  Future<void> updateOrderStatus(int orderId, String status);
}
