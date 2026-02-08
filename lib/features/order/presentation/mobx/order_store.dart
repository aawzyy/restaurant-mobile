import 'package:mobx/mobx.dart';
// Import UseCases
import '../../../table/domain/usecases/get_tables_usecase.dart';
import '../../domain/usecases/submit_order_usecase.dart';
// PENTING: Import Entity agar tidak error "InvalidType"
import '../../../table/domain/entities/table_entity.dart';
import '../../../menu/domain/entities/menu_entity.dart';

part 'order_store.g.dart';

class OrderStore = _OrderStoreBase with _$OrderStore;

abstract class _OrderStoreBase with Store {
  final GetTablesUseCase getTablesUseCase;
  final SubmitOrderUseCase submitOrderUseCase;

  _OrderStoreBase({
    required this.getTablesUseCase,
    required this.submitOrderUseCase,
  });

  // Tipe Data TableEntity (Pastikan sudah di-import di atas)
  @observable
  ObservableList<TableEntity> tables = ObservableList<TableEntity>();

  @observable
  int? selectedTableId;

  @observable
  ObservableList<Map<String, dynamic>> cartItems =
      ObservableList<Map<String, dynamic>>();

  @observable
  bool isLoading = false;

  @observable
  String? successMessage;

  @observable
  String? errorMessage;

  @computed
  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      MenuEntity menu = item['menu'];
      int qty = item['qty'];
      total += (menu.price * qty);
    }
    return total;
  }

  @computed
  int get totalItems =>
      cartItems.fold(0, (sum, item) => sum + (item['qty'] as int));

  @action
  Future<void> fetchTables() async {
    try {
      final result = await getTablesUseCase.execute();
      tables.clear();
      tables.addAll(result);
    } catch (e) {
      print("Store Error: $e");
    }
  }

  @action
  Future<bool> submitOrder() async {
    if (selectedTableId == null) {
      errorMessage = "Mohon pilih meja terlebih dahulu!";
      return false;
    }
    if (cartItems.isEmpty) return false;

    isLoading = true;
    errorMessage = null;

    try {
      List<Map<String, dynamic>> itemsApi = cartItems.map((e) {
        return {
          "menu_id": (e['menu'] as MenuEntity).id,
          "quantity": e['qty'],
          "notes": e['note'] ?? "-",
        };
      }).toList();

      await submitOrderUseCase.execute(selectedTableId!, itemsApi);

      successMessage = "Pesanan berhasil dikirim ke dapur!";
      cartItems.clear();
      selectedTableId = null;
      return true;
    } catch (e) {
      errorMessage = "Gagal mengirim pesanan. Coba lagi.";
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  void selectTable(int id) => selectedTableId = id;

  @action
  void addToCart(MenuEntity menu, {int quantity = 1, String note = ''}) {
    int index = cartItems.indexWhere((item) => item['menu'].id == menu.id);
    if (index != -1) {
      var oldItem = cartItems[index];
      var newItem = Map<String, dynamic>.from(oldItem);
      newItem['qty'] = (newItem['qty'] as int) + quantity;
      cartItems[index] = newItem;
    } else {
      cartItems.add({'menu': menu, 'qty': quantity, 'note': note});
    }
  }

  @action
  void decreaseItem(int index) {
    var oldItem = cartItems[index];
    int currentQty = oldItem['qty'] as int;
    if (currentQty > 1) {
      var newItem = Map<String, dynamic>.from(oldItem);
      newItem['qty'] = currentQty - 1;
      cartItems[index] = newItem;
    } else {
      cartItems.removeAt(index);
    }
  }
}
