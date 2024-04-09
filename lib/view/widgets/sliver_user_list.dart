import 'package:excercise/model/user_model.dart';
import 'package:flutter/material.dart';

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
