// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$KitchenStore on _KitchenStoreBase, Store {
  Computed<List<OrderEntity>>? _$filteredOrdersComputed;

  @override
  List<OrderEntity> get filteredOrders =>
      (_$filteredOrdersComputed ??= Computed<List<OrderEntity>>(
        () => super.filteredOrders,
        name: '_KitchenStoreBase.filteredOrders',
      )).value;

  late final _$activeOrdersAtom = Atom(
    name: '_KitchenStoreBase.activeOrders',
    context: context,
  );

  @override
  ObservableList<OrderEntity> get activeOrders {
    _$activeOrdersAtom.reportRead();
    return super.activeOrders;
  }

  @override
  set activeOrders(ObservableList<OrderEntity> value) {
    _$activeOrdersAtom.reportWrite(value, super.activeOrders, () {
      super.activeOrders = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_KitchenStoreBase.isLoading',
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
    name: '_KitchenStoreBase.errorMessage',
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

  late final _$searchQueryAtom = Atom(
    name: '_KitchenStoreBase.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$filterStatusAtom = Atom(
    name: '_KitchenStoreBase.filterStatus',
    context: context,
  );

  @override
  String get filterStatus {
    _$filterStatusAtom.reportRead();
    return super.filterStatus;
  }

  @override
  set filterStatus(String value) {
    _$filterStatusAtom.reportWrite(value, super.filterStatus, () {
      super.filterStatus = value;
    });
  }

  late final _$fetchKitchenOrdersAsyncAction = AsyncAction(
    '_KitchenStoreBase.fetchKitchenOrders',
    context: context,
  );

  @override
  Future<void> fetchKitchenOrders() {
    return _$fetchKitchenOrdersAsyncAction.run(
      () => super.fetchKitchenOrders(),
    );
  }

  late final _$updateStatusAsyncAction = AsyncAction(
    '_KitchenStoreBase.updateStatus',
    context: context,
  );

  @override
  Future<void> updateStatus(int orderId, String newStatus) {
    return _$updateStatusAsyncAction.run(
      () => super.updateStatus(orderId, newStatus),
    );
  }

  late final _$_KitchenStoreBaseActionController = ActionController(
    name: '_KitchenStoreBase',
    context: context,
  );

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_KitchenStoreBaseActionController.startAction(
      name: '_KitchenStoreBase.setSearchQuery',
    );
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_KitchenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFilterStatus(String status) {
    final _$actionInfo = _$_KitchenStoreBaseActionController.startAction(
      name: '_KitchenStoreBase.setFilterStatus',
    );
    try {
      return super.setFilterStatus(status);
    } finally {
      _$_KitchenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
activeOrders: ${activeOrders},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
searchQuery: ${searchQuery},
filterStatus: ${filterStatus},
filteredOrders: ${filteredOrders}
    ''';
  }
}
