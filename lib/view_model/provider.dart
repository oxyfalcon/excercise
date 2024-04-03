import 'package:excercise/model/api/api.dart';
import 'package:excercise/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserModelNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<UserModel>, int> {
  @override
  Future<List<UserModel>> build(int arg) async =>
      arg == 1 ? [] : await Api().getUserModel(arg);
}

final AutoDisposeAsyncNotifierProviderFamily<UserModelNotifier, List<UserModel>,
        int> userListProvider =
    AutoDisposeAsyncNotifierProviderFamily<UserModelNotifier, List<UserModel>,
        int>(() => UserModelNotifier());

class PageNumberNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() => 1;

  void change(int pageNumber) => state = pageNumber;
}

final pageNumberProvider = AutoDisposeNotifierProvider<PageNumberNotifier, int>(
    () => PageNumberNotifier());

class FullListNotifier extends AutoDisposeAsyncNotifier<List<UserModel>> {
  @override
  Future<List<UserModel>> build() async => await Api().getUserModel(1);

  void appendList(List<UserModel> nextUserList) {
    if (state.value != null) {
      state = AsyncValue.data([...state.value!, ...nextUserList]);
    }
  }
}

final fullListProvider =
    AutoDisposeAsyncNotifierProvider<FullListNotifier, List<UserModel>>(
        () => FullListNotifier());
