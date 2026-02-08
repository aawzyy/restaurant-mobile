import 'dart:io';
import 'package:dio/dio.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_data_source.dart';
import '../models/menu_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MenuEntity>> getMenus() async {
    final response = await remoteDataSource.getMenus();
    final List data = response.data['data'];
    return data.map((json) => MenuModel.fromJson(json)).toList();
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final response = await remoteDataSource.getCategories();
    final List data = response.data['data'];
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<void> createMenu({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    File? imageFile,
  }) async {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "price": price,
      "category_id": categoryId,
    };

    if (imageFile != null) {
      data["image"] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    await remoteDataSource.createMenu(FormData.fromMap(data));
  }

  @override
  Future<void> updateMenu({
    required int id,
    required String name,
    required String description,
    required double price,
    required int categoryId,
    File? imageFile,
  }) async {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "price": price,
      "category_id": categoryId,
      "_method":
          "PUT", // Laravel butuh _method PUT jika kirim Multipart/FormData
    };

    if (imageFile != null) {
      data["image"] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    await remoteDataSource.updateMenu(id, FormData.fromMap(data));
  }

  @override
  Future<void> deleteMenu(int id) async {
    await remoteDataSource.deleteMenu(id);
  }
}
