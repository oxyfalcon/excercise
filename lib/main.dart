import 'package:excercise/l10n/app_localizations.dart';
import 'package:excercise/model/user_model.dart';
import 'package:excercise/utils/config.dart';
import 'package:excercise/view_model/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config().initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      locale: const Locale('es'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProviderScope(child: MyHomePage()),
    );
  }
}

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

class SliverUserList extends StatelessWidget {
  const SliverUserList({super.key, required this.list});

  final List<UserModel> list;

  @override
  Widget build(BuildContext context) {
    return (list.isNotEmpty)
        ? SliverList.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.onSecondary,
                child: ListTile(title: Text(list[index].title.toString()))),
          )
        : const SliverFillRemaining(
            child: Center(child: Text("No Articles found")),
          );
  }
}
