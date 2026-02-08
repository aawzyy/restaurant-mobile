import 'package:dio/dio.dart';
import '../models/table_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<TableModel>> fetchTables();
  Future<bool> postOrder(Map<String, dynamic> data);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TableModel>> fetchTables() async {
    final response = await dio.get('/tables');
    final List data = response.data['data'];
    // Konversi JSON ke Model di sini
    return data.map((json) => TableModel.fromJson(json)).toList();
  }

  @override
  Future<bool> postOrder(Map<String, dynamic> data) async {
    final response = await dio.post('/orders', data: data);
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
