import 'package:excercise/view_model/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliverLoading extends ConsumerWidget {
  const SliverLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userListProvider(ref.watch(pageNumberProvider))).when(
        data: (list) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
              ref.watch(fullListProvider.notifier).appendList(list));
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
        error: (error, stackTrace) =>
            SliverFillRemaining(child: Center(child: Text(error.toString()))),
        loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator.adaptive())));
  }
}
