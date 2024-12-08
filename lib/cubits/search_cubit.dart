import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasocial/entities/repository/search_repo.dart';
import 'package:mediasocial/cubits/states/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      print(users);
      emit(SearchLoaded(users: users));
    } catch (e) {
      emit(SearchError(message: "Error in Search $e"));
    }
  }
}
