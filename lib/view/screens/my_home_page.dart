import 'package:excercise/l10n/app_localizations.dart';
import 'package:excercise/view/widgets/sliver_loading.dart';
import 'package:excercise/view/user_list.dart';
import 'package:excercise/view_model/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        int pageNumber = ref.read(pageNumberProvider);
        pageNumber += 1;
        ref.watch(pageNumberProvider.notifier).change(pageNumber);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          child: const Icon(Icons.login),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(AppLocalizations.of(context)!.helloWorld),
            centerTitle: true),
        body: RefreshIndicator(
          child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: const <Widget>[UserList(), SliverLoading()]),
          onRefresh: () async {
            ref.watch(pageNumberProvider.notifier).change(1);
            ref.invalidate(fullListProvider);
          },
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
