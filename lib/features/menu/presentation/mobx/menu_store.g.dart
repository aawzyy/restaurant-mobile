// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MenuStore on _MenuStoreBase, Store {
  Computed<List<MenuEntity>>? _$filteredMenusComputed;

  @override
  List<MenuEntity> get filteredMenus =>
      (_$filteredMenusComputed ??= Computed<List<MenuEntity>>(
        () => super.filteredMenus,
        name: '_MenuStoreBase.filteredMenus',
      )).value;

  late final _$menusAtom = Atom(name: '_MenuStoreBase.menus', context: context);

  @override
  ObservableList<MenuEntity> get menus {
    _$menusAtom.reportRead();
    return super.menus;
  }

  @override
  set menus(ObservableList<MenuEntity> value) {
    _$menusAtom.reportWrite(value, super.menus, () {
      super.menus = value;
    });
  }

  late final _$categoriesAtom = Atom(
    name: '_MenuStoreBase.categories',
    context: context,
  );

  @override
  ObservableList<CategoryEntity> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(ObservableList<CategoryEntity> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_MenuStoreBase.isLoading',
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
    name: '_MenuStoreBase.errorMessage',
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

  late final _$selectedCategoryIdAtom = Atom(
    name: '_MenuStoreBase.selectedCategoryId',
    context: context,
  );

  @override
  int get selectedCategoryId {
    _$selectedCategoryIdAtom.reportRead();
    return super.selectedCategoryId;
  }

  @override
  set selectedCategoryId(int value) {
    _$selectedCategoryIdAtom.reportWrite(value, super.selectedCategoryId, () {
      super.selectedCategoryId = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_MenuStoreBase.searchQuery',
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

  late final _$fetchMenusAsyncAction = AsyncAction(
    '_MenuStoreBase.fetchMenus',
    context: context,
  );

  @override
  Future<void> fetchMenus({bool isRetry = false}) {
    return _$fetchMenusAsyncAction.run(
      () => super.fetchMenus(isRetry: isRetry),
    );
  }

  late final _$fetchCategoriesAsyncAction = AsyncAction(
    '_MenuStoreBase.fetchCategories',
    context: context,
  );

  @override
  Future<void> fetchCategories() {
    return _$fetchCategoriesAsyncAction.run(() => super.fetchCategories());
  }

  late final _$addMenuAsyncAction = AsyncAction(
    '_MenuStoreBase.addMenu',
    context: context,
  );

  @override
  Future<void> addMenu({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    File? imageFile,
  }) {
    return _$addMenuAsyncAction.run(
      () => super.addMenu(
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        imageFile: imageFile,
      ),
    );
  }

  late final _$removeMenuAsyncAction = AsyncAction(
    '_MenuStoreBase.removeMenu',
    context: context,
  );

  @override
  Future<void> removeMenu(int id) {
    return _$removeMenuAsyncAction.run(() => super.removeMenu(id));
  }

  late final _$_MenuStoreBaseActionController = ActionController(
    name: '_MenuStoreBase',
    context: context,
  );

  @override
  void setCategory(int id) {
    final _$actionInfo = _$_MenuStoreBaseActionController.startAction(
      name: '_MenuStoreBase.setCategory',
    );
    try {
      return super.setCategory(id);
    } finally {
      _$_MenuStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_MenuStoreBaseActionController.startAction(
      name: '_MenuStoreBase.setSearchQuery',
    );
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_MenuStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
menus: ${menus},
categories: ${categories},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
selectedCategoryId: ${selectedCategoryId},
searchQuery: ${searchQuery},
filteredMenus: ${filteredMenus}
    ''';
  }
}
