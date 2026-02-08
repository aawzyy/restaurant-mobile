import 'package:dio/dio.dart';

abstract class MenuRemoteDataSource {
  Future<Response> getMenus();
  Future<Response> getCategories();
  Future<Response> createMenu(FormData data);
  Future<Response> updateMenu(int id, FormData data);
  Future<Response> deleteMenu(int id);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final Dio dio;
  MenuRemoteDataSourceImpl(this.dio);

  @override
  Future<Response> getMenus() => dio.get('/menus');

  @override
  Future<Response> getCategories() => dio.get('/categories');

  @override
  Future<Response> createMenu(FormData data) => dio.post('/menus', data: data);

  @override
  Future<Response> updateMenu(int id, FormData data) =>
      dio.post('/menus/$id', data: data);

  @override
  Future<Response> deleteMenu(int id) => dio.delete('/menus/$id');
}
