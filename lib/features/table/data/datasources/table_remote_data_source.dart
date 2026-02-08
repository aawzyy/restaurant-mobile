import 'package:dio/dio.dart';
import '../models/table_model.dart';

abstract class TableRemoteDataSource {
  Future<List<TableModel>> fetchTables();
}

class TableRemoteDataSourceImpl implements TableRemoteDataSource {
  final Dio dio;

  TableRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TableModel>> fetchTables() async {
    final response = await dio.get('/tables');
    final List data = response.data['data'];
    return data.map((json) => TableModel.fromJson(json)).toList();
  }
}
