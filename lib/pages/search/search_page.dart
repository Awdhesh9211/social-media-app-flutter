import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/pages/components/profile/user_tile.dart';
import 'package:mediasocial/cubits/search_cubit.dart';
import 'package:mediasocial/cubits/states/search_state.dart';
import 'package:mediasocial/pages/responsive/constrained_scaffold.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchcontroller = TextEditingController();

  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchcontroller.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchcontroller.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      // APPBAR
      appBar: AppBar(
        title: TextField(
          controller: searchcontroller,
          decoration: InputDecoration(
              hintText: "Search users....",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              )),
        ),
      ),

      // SEARCH RESULT
      body: BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
        // loaded
        if (state is SearchLoaded) {
          if (state.users.isEmpty) {
            return const Center(
              child: Text("No User Found..."),
            );
          }
          return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              });
        }

        // loading
        else if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // error
        else if (state is SearchError) {
          return Center(
            child: Text(state.message),
          );
        }

        // default
        return const Center(
          child: Text("Start Searching for users ..."),
        );
      }),
    );
  }
}
