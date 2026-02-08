import 'dart:io';
import 'package:mobx/mobx.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/usecases/get_menus_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/create_menu_usecase.dart';
import '../../domain/usecases/update_menu_usecase.dart';
import '../../domain/usecases/delete_menu_usecase.dart';

part 'menu_store.g.dart';

class MenuStore = _MenuStoreBase with _$MenuStore;

abstract class _MenuStoreBase with Store {
  final GetMenusUseCase getMenusUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateMenuUseCase createMenuUseCase;
  final UpdateMenuUseCase updateMenuUseCase;
  final DeleteMenuUseCase deleteMenuUseCase;

  _MenuStoreBase({
    required this.getMenusUseCase,
    required this.getCategoriesUseCase,
    required this.createMenuUseCase,
    required this.updateMenuUseCase,
    required this.deleteMenuUseCase,
  });

  // --- STATE UTAMA ---
  @observable
  ObservableList<MenuEntity> menus = ObservableList<MenuEntity>();

  @observable
  ObservableList<CategoryEntity> categories = ObservableList<CategoryEntity>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  // --- STATE FILTERING ---
  @observable
  int selectedCategoryId = 0; // 0 artinya "ALL"

  @observable
  String searchQuery = ''; // Menyimpan teks pencarian

  // --- ACTIONS ---
  @action
  void setCategory(int id) {
    selectedCategoryId = id;
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  // --- LOGIKA FILTERING PINTAR (COMPUTED) ---
  @computed
  List<MenuEntity> get filteredMenus {
    return menus.where((menu) {
      // 1. Cek Kategori (Jika 0 ambil semua, jika tidak cocokkan ID)
      bool matchCategory = true;
      if (selectedCategoryId != 0) {
        matchCategory = menu.category.id == selectedCategoryId;
      }

      // 2. Cek Search Text (Nama Menu)
      bool matchSearch = true;
      if (searchQuery.isNotEmpty) {
        matchSearch = menu.name.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
      }

      // Gabungkan kedua syarat (AND)
      return matchCategory && matchSearch;
    }).toList();
  }

  // --- API CALLS (TETAP SAMA) ---
  @action
  Future<void> fetchMenus({bool isRetry = false}) async {
    if (!isRetry) {
      isLoading = true;
      errorMessage = null;
    }
    try {
      final result = await getMenusUseCase.execute();
      menus.clear();
      menus.addAll(result);
      errorMessage = null;
    } catch (e) {
      if (!isRetry) {
        await Future.delayed(const Duration(milliseconds: 800));
        return fetchMenus(isRetry: true);
      }
      errorMessage = "Gagal mengambil data menu.";
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> fetchCategories() async {
    try {
      final result = await getCategoriesUseCase.execute();
      categories.clear();
      categories.addAll(result);
    } catch (e) {
      print("CategoryStore Error: $e");
    }
  }

  @action
  Future<void> addMenu({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    File? imageFile,
  }) async {
    isLoading = true;
    try {
      await createMenuUseCase.execute(
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        imageFile: imageFile,
      );
      await fetchMenus();
    } catch (e) {
      errorMessage = "Gagal menambah menu";
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> removeMenu(int id) async {
    isLoading = true;
    try {
      await deleteMenuUseCase.execute(id);
      menus.removeWhere((element) => element.id == id);
    } catch (e) {
      errorMessage = "Gagal menghapus menu";
    } finally {
      isLoading = false;
    }
  }
}
