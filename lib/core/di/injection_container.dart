import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- CORE & NETWORK ---
import '../network/dio_client.dart';

// --- FEATURE: AUTHENTICATION ---
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/mobx/auth_store.dart';
import '../../features/auth/domain/usecases/google_login_usecase.dart';

// --- FEATURE: MENU ---
import '../../features/menu/data/datasources/menu_remote_data_source.dart';
import '../../features/menu/data/repositories/menu_repository_impl.dart';
import '../../features/menu/domain/repositories/menu_repository.dart';
import '../../features/menu/domain/usecases/get_menus_usecase.dart';
import '../../features/menu/domain/usecases/get_categories_usecase.dart';
import '../../features/menu/domain/usecases/create_menu_usecase.dart';
import '../../features/menu/domain/usecases/update_menu_usecase.dart';
import '../../features/menu/domain/usecases/delete_menu_usecase.dart';
import '../../features/menu/presentation/mobx/menu_store.dart';

// --- FEATURE: TABLE (NEW & CLEAN) ---
import '../../features/table/data/datasources/table_remote_data_source.dart';
import '../../features/table/data/repositories/table_repository_impl.dart';
import '../../features/table/domain/repositories/table_repository.dart';
import '../../features/table/domain/usecases/get_tables_usecase.dart';
import '../../features/table/presentation/mobx/table_store.dart';

// --- FEATURE: ORDER (REFACTORED) ---
import '../../features/order/data/datasources/order_remote_data_source.dart';
import '../../features/order/data/repositories/order_repository_impl.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/order/domain/usecases/submit_order_usecase.dart';
import '../../features/order/presentation/mobx/order_store.dart';

// --- FEATURE: KITCHEN ---
import '../../features/kitchen/data/datasources/kitchen_remote_data_source.dart';
import '../../features/kitchen/data/repositories/kitchen_repository_impl.dart';
import '../../features/kitchen/domain/repositories/kitchen_repository.dart';
// Asumsi kamu sudah buat UseCase GetKitchenOrders, jika belum bisa skip baris UseCase
import '../../features/kitchen/domain/usecases/get_kitchen_orders_usecase.dart';
import '../../features/kitchen/domain/usecases/update_order_status_usecase.dart';
import '../../features/kitchen/presentation/mobx/kitchen_store.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ===========================================================================
  // 1. EXTERNAL & CORE
  // ===========================================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Menggunakan DioClient yang sudah disetup dengan Interceptor (Token)
  sl.registerLazySingleton<Dio>(() => DioClient().instance);

  // ===========================================================================
  // 2. FEATURE: AUTHENTICATION
  // ===========================================================================

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => GoogleLoginUseCase(sl()));

  // Store
  sl.registerLazySingleton(
    () => AuthStore(
      loginUseCase: sl(),
      verifyOtpUseCase: sl(),
      localDataSource: sl(),
      googleLoginUseCase: sl(),
    ),
  );

  // ===========================================================================
  // 3. FEATURE: MENU
  // ===========================================================================

  // Data Source
  sl.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetMenusUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => CreateMenuUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMenuUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMenuUseCase(sl()));

  // Store
  sl.registerLazySingleton(
    () => MenuStore(
      getMenusUseCase: sl(),
      getCategoriesUseCase: sl(),
      createMenuUseCase: sl(),
      updateMenuUseCase: sl(),
      deleteMenuUseCase: sl(),
    ),
  );

  // ===========================================================================
  // 4. FEATURE: TABLE (Sumber Data Meja)
  // ===========================================================================

  // Data Source
  sl.registerLazySingleton<TableRemoteDataSource>(
    () => TableRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<TableRepository>(() => TableRepositoryImpl(sl()));

  // Use Case
  // GetTablesUseCase didaftarkan di sini.
  // UseCase ini akan dipakai oleh TableStore DAN OrderStore.
  sl.registerLazySingleton(() => GetTablesUseCase(sl()));

  // Store (Untuk TableScreen)
  sl.registerLazySingleton(() => TableStore(sl()));

  // ===========================================================================
  // 5. FEATURE: ORDER (Menggunakan resource dari Table)
  // ===========================================================================

  // Data Source
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Case (Hanya Submit, karena GetTables pinjam dari fitur Table)
  sl.registerLazySingleton(() => SubmitOrderUseCase(sl()));

  // Store (Untuk CartScreen)
  sl.registerLazySingleton(
    () => OrderStore(
      getTablesUseCase: sl(), // Mengambil GetTablesUseCase milik fitur Table
      submitOrderUseCase: sl(),
    ),
  );

  // ===========================================================================
  // 6. FEATURE: KITCHEN (FULL CLEAN ARCH)
  // ===========================================================================

  // Data Source
  sl.registerLazySingleton<KitchenRemoteDataSource>(
    () => KitchenRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<KitchenRepository>(
    () => KitchenRepositoryImpl(sl()),
  );

  // Use Cases (JANGAN LUPA DAFTARKAN INI)
  sl.registerLazySingleton(() => GetKitchenOrdersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));

  // Store
  // Inject UseCases ke dalam Store
  sl.registerLazySingleton(
    () => KitchenStore(
      getKitchenOrdersUseCase: sl(),
      updateOrderStatusUseCase: sl(),
    ),
  );
}
