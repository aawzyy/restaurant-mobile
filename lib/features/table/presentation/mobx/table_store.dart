import 'package:mobx/mobx.dart';
import '../../domain/entities/table_entity.dart';
import '../../domain/usecases/get_tables_usecase.dart';

part 'table_store.g.dart';

class TableStore = _TableStoreBase with _$TableStore;

abstract class _TableStoreBase with Store {
  final GetTablesUseCase getTablesUseCase;

  _TableStoreBase(this.getTablesUseCase);

  @observable
  ObservableList<TableEntity> tables = ObservableList<TableEntity>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> fetchTables() async {
    isLoading = true;
    errorMessage = null;
    try {
      final result = await getTablesUseCase.execute();
      tables.clear();
      tables.addAll(result);
    } catch (e) {
      errorMessage = "Gagal memuat meja";
      print("TableStore Error: $e");
    } finally {
      isLoading = false;
    }
  }
}
