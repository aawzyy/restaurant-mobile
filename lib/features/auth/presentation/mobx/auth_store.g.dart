// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStoreBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_AuthStoreBase.isLoading',
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
    name: '_AuthStoreBase.errorMessage',
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

  late final _$isOtpSentAtom = Atom(
    name: '_AuthStoreBase.isOtpSent',
    context: context,
  );

  @override
  bool get isOtpSent {
    _$isOtpSentAtom.reportRead();
    return super.isOtpSent;
  }

  @override
  set isOtpSent(bool value) {
    _$isOtpSentAtom.reportWrite(value, super.isOtpSent, () {
      super.isOtpSent = value;
    });
  }

  late final _$userAtom = Atom(name: '_AuthStoreBase.user', context: context);

  @override
  UserEntity? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserEntity? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$isAuthenticatedAtom = Atom(
    name: '_AuthStoreBase.isAuthenticated',
    context: context,
  );

  @override
  bool get isAuthenticated {
    _$isAuthenticatedAtom.reportRead();
    return super.isAuthenticated;
  }

  @override
  set isAuthenticated(bool value) {
    _$isAuthenticatedAtom.reportWrite(value, super.isAuthenticated, () {
      super.isAuthenticated = value;
    });
  }

  late final _$checkLoginStatusAsyncAction = AsyncAction(
    '_AuthStoreBase.checkLoginStatus',
    context: context,
  );

  @override
  Future<void> checkLoginStatus() {
    return _$checkLoginStatusAsyncAction.run(() => super.checkLoginStatus());
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_AuthStoreBase.logout',
    context: context,
  );

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$loginAsyncAction = AsyncAction(
    '_AuthStoreBase.login',
    context: context,
  );

  @override
  Future<void> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$verifyOtpAsyncAction = AsyncAction(
    '_AuthStoreBase.verifyOtp',
    context: context,
  );

  @override
  Future<void> verifyOtp(String email, String otp) {
    return _$verifyOtpAsyncAction.run(() => super.verifyOtp(email, otp));
  }

  late final _$loginWithGoogleAsyncAction = AsyncAction(
    '_AuthStoreBase.loginWithGoogle',
    context: context,
  );

  @override
  Future<void> loginWithGoogle() {
    return _$loginWithGoogleAsyncAction.run(() => super.loginWithGoogle());
  }

  late final _$_AuthStoreBaseActionController = ActionController(
    name: '_AuthStoreBase',
    context: context,
  );

  @override
  void resetError() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.resetError',
    );
    try {
      return super.resetError();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isOtpSent: ${isOtpSent},
user: ${user},
isAuthenticated: ${isAuthenticated}
    ''';
  }
}
