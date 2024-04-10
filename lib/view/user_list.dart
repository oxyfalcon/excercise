import 'package:excercise/view/widgets/sliver_user_list.dart';
import 'package:excercise/view_model/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserList extends ConsumerWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(fullListProvider).when(
        data: (list) => SliverUserList(list: list),
        error: (error, stackTrace) =>
            SliverFillRemaining(child: Center(child: Text(error.toString()))),
        loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator.adaptive())));
  }
}
