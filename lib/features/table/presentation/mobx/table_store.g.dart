// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TableStore on _TableStoreBase, Store {
  late final _$tablesAtom = Atom(
    name: '_TableStoreBase.tables',
    context: context,
  );

  @override
  ObservableList<TableEntity> get tables {
    _$tablesAtom.reportRead();
    return super.tables;
  }

  @override
  set tables(ObservableList<TableEntity> value) {
    _$tablesAtom.reportWrite(value, super.tables, () {
      super.tables = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_TableStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_TableStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$fetchTablesAsyncAction = AsyncAction(
    '_TableStoreBase.fetchTables',
    context: context,
  );

  @override
  Future<void> fetchTables() {
    return _$fetchTablesAsyncAction.run(() => super.fetchTables());
  }

  @override
  String toString() {
    return '''
tables: ${tables},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
