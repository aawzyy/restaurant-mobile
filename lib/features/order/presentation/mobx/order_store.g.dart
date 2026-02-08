// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderStore on _OrderStoreBase, Store {
  Computed<double>? _$totalPriceComputed;

  @override
  double get totalPrice => (_$totalPriceComputed ??= Computed<double>(
    () => super.totalPrice,
    name: '_OrderStoreBase.totalPrice',
  )).value;
  Computed<int>? _$totalItemsComputed;

  @override
  int get totalItems => (_$totalItemsComputed ??= Computed<int>(
    () => super.totalItems,
    name: '_OrderStoreBase.totalItems',
  )).value;

  late final _$tablesAtom = Atom(
    name: '_OrderStoreBase.tables',
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

  late final _$selectedTableIdAtom = Atom(
    name: '_OrderStoreBase.selectedTableId',
    context: context,
  );

  @override
  int? get selectedTableId {
    _$selectedTableIdAtom.reportRead();
    return super.selectedTableId;
  }

  @override
  set selectedTableId(int? value) {
    _$selectedTableIdAtom.reportWrite(value, super.selectedTableId, () {
      super.selectedTableId = value;
    });
  }

  late final _$cartItemsAtom = Atom(
    name: '_OrderStoreBase.cartItems',
    context: context,
  );

  @override
  ObservableList<Map<String, dynamic>> get cartItems {
    _$cartItemsAtom.reportRead();
    return super.cartItems;
  }

  @override
  set cartItems(ObservableList<Map<String, dynamic>> value) {
    _$cartItemsAtom.reportWrite(value, super.cartItems, () {
      super.cartItems = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_OrderStoreBase.isLoading',
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

  late final _$successMessageAtom = Atom(
    name: '_OrderStoreBase.successMessage',
    context: context,
  );

  @override
  String? get successMessage {
    _$successMessageAtom.reportRead();
    return super.successMessage;
  }

  @override
  set successMessage(String? value) {
    _$successMessageAtom.reportWrite(value, super.successMessage, () {
      super.successMessage = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_OrderStoreBase.errorMessage',
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
    '_OrderStoreBase.fetchTables',
    context: context,
  );

  @override
  Future<void> fetchTables() {
    return _$fetchTablesAsyncAction.run(() => super.fetchTables());
  }

  late final _$submitOrderAsyncAction = AsyncAction(
    '_OrderStoreBase.submitOrder',
    context: context,
  );

  @override
  Future<bool> submitOrder() {
    return _$submitOrderAsyncAction.run(() => super.submitOrder());
  }

  late final _$_OrderStoreBaseActionController = ActionController(
    name: '_OrderStoreBase',
    context: context,
  );

  @override
  void selectTable(int id) {
    final _$actionInfo = _$_OrderStoreBaseActionController.startAction(
      name: '_OrderStoreBase.selectTable',
    );
    try {
      return super.selectTable(id);
    } finally {
      _$_OrderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToCart(MenuEntity menu, {int quantity = 1, String note = ''}) {
    final _$actionInfo = _$_OrderStoreBaseActionController.startAction(
      name: '_OrderStoreBase.addToCart',
    );
    try {
      return super.addToCart(menu, quantity: quantity, note: note);
    } finally {
      _$_OrderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decreaseItem(int index) {
    final _$actionInfo = _$_OrderStoreBaseActionController.startAction(
      name: '_OrderStoreBase.decreaseItem',
    );
    try {
      return super.decreaseItem(index);
    } finally {
      _$_OrderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tables: ${tables},
selectedTableId: ${selectedTableId},
cartItems: ${cartItems},
isLoading: ${isLoading},
successMessage: ${successMessage},
errorMessage: ${errorMessage},
totalPrice: ${totalPrice},
totalItems: ${totalItems}
    ''';
  }
}
