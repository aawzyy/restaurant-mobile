import 'dart:io';
import '../entities/menu_entity.dart';

abstract class MenuRepository {
  // Ambil semua daftar menu
  Future<List<MenuEntity>> getMenus();

  // Ambil semua kategori untuk dropdown saat tambah/edit menu
  Future<List<CategoryEntity>> getCategories();

  // Create: Tambah menu baru dengan upload gambar ke MinIO via Laravel
  Future<void> createMenu({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    File? imageFile,
  });

  // Update: Ubah data menu yang sudah ada
  Future<void> updateMenu({
    required int id,
    required String name,
    required String description,
    required double price,
    required int categoryId,
    File? imageFile,
  });

  // Delete: Hapus menu
  Future<void> deleteMenu(int id);
}
