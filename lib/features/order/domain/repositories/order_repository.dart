import '../../../table/domain/entities/table_entity.dart'; // (Opsional, atau pakai Map/Dynamic dulu biar cepat)
// Kita pakai dynamic/Map dulu untuk input checkout biar ringkas untuk test ini

abstract class OrderRepository {
  Future<List<TableEntity>> getTables();

  Future<bool> submitOrder({
    required int tableId,
    required List<Map<String, dynamic>> items,
  });
}
