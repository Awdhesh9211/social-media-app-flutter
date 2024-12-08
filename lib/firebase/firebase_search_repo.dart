import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediasocial/entities/models/profile_user.dart';
import 'package:mediasocial/entities/repository/search_repo.dart';

class FirebasesearchRepo implements SearchRepo {
  @override
  Future<List<ProfileUser?>> searchUsers(String query) async {
    try {
    

      // Ensure that the query is lowercase for consistent case-insensitive searching.
      final lowerCaseQuery = query.toLowerCase();

      // Query for names starting with the query string (prefix matching).
      final result = await FirebaseFirestore.instance
          .collection("users")
          .where('name', isGreaterThanOrEqualTo: lowerCaseQuery)
          .where('name',
              isLessThanOrEqualTo:
                  '$lowerCaseQuery\uf8ff') // Firestore trick for inclusive search
          .get();

      print("Documents fetched: ${result.docs.length}");
      print("Fetched data: ${result.docs.map((doc) => doc.data()).toList()}");

      // Convert the Firestore documents to ProfileUser objects
      return result.docs
          .map((doc) => ProfileUser.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error while Fetching users ....: $e");
    }
  }
}
