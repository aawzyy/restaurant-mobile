import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../domain/usecases/get_kitchen_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../../order/domain/entities/order_entity.dart'; // PENTING: Import Entity

part 'kitchen_store.g.dart';

class KitchenStore = _KitchenStoreBase with _$KitchenStore;

abstract class _KitchenStoreBase with Store {
  final GetKitchenOrdersUseCase getKitchenOrdersUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  Timer? _timer;

  _KitchenStoreBase({
    required this.getKitchenOrdersUseCase,
    required this.updateOrderStatusUseCase,
  });

  // --- STATE UTAMA ---
  @observable
  ObservableList<OrderEntity> activeOrders = ObservableList<OrderEntity>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  // --- STATE FILTER & SEARCH (Client Side) ---
  @observable
  String searchQuery = '';

  @observable
  String filterStatus = 'all'; // Pilihan: 'all', 'pending', 'processing'

  // --- ACTION UNTUK UBAH FILTER ---
  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  @action
  void setFilterStatus(String status) {
    filterStatus = status;
  }

  // --- LOGIKA FILTERING OTOMATIS (COMPUTED) ---
  @computed
  List<OrderEntity> get filteredOrders {
    return activeOrders.where((order) {
      // 1. Cek Filter Status
      bool matchStatus = true;
      if (filterStatus != 'all') {
        matchStatus = order.status == filterStatus;
      }

      // 2. Cek Search Query (Bisa cari No Meja ATAU Nama Menu)
      bool matchSearch = true;
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();

        // Cari berdasarkan Nomor Meja
        final tableMatch = order.tableNumber.toLowerCase().contains(query);

        // Cari berdasarkan Nama Menu di dalam orderan
        // (Contoh: ketik "Nasi", orderan meja yg pesan nasi akan muncul)
        final menuMatch = order.items.any(
          (item) => item.menuName.toLowerCase().contains(query),
        );

        matchSearch = tableMatch || menuMatch;
      }

      return matchStatus && matchSearch;
    }).toList();
  }

  // --- DATA FETCHING & UPDATING ---

  @action
  Future<void> fetchKitchenOrders() async {
    try {
      final result = await getKitchenOrdersUseCase.execute();
      activeOrders.clear();
      activeOrders.addAll(result);
    } catch (e) {
      print("Kitchen Error: $e");
    }
  }

  @action
  Future<void> updateStatus(int orderId, String newStatus) async {
    isLoading = true;
    try {
      await updateOrderStatusUseCase.execute(orderId, newStatus);
      await fetchKitchenOrders(); // Refresh data setelah update
    } catch (e) {
      errorMessage = "Gagal update status";
    } finally {
      isLoading = false;
    }
  }

  // Auto Refresh Logic (Setiap 5 detik)
  void startAutoRefresh() {
    fetchKitchenOrders();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchKitchenOrders();
    });
  }

  void stopAutoRefresh() {
    _timer?.cancel();
  }
}
