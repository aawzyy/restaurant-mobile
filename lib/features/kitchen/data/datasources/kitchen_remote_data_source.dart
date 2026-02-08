import 'package:dio/dio.dart';
// Import Model dari fitur Order
import '../../../order/data/models/order_model.dart';

abstract class KitchenRemoteDataSource {
  Future<List<OrderModel>> fetchKitchenOrders();
  Future<void> updateStatus(int id, String status);
}

class KitchenRemoteDataSourceImpl implements KitchenRemoteDataSource {
  final Dio dio;
  KitchenRemoteDataSourceImpl(this.dio);

  @override
  Future<List<OrderModel>> fetchKitchenOrders() async {
    final response = await dio.get('/kitchen/orders');
    final List data = response.data['data'];
    // Konversi JSON -> OrderModel
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  @override
  Future<void> updateStatus(int id, String status) async {
    await dio.patch('/orders/$id/status', data: {'status': status});
  }
}
