import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediasocial/entities/models/profile_user.dart';
import 'package:mediasocial/entities/repository/search_repo.dart';

class FirebasesearchRepo implements SearchRepo {
  @override
  Future<List<ProfileUser?>> searchUsers(String query) async {
    try {
      print("Query $query");
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

      print("Fetched data: ${result.docs.map((doc) => doc.data()).toList()}");

      // Convert the Firestore documents to ProfileUser objects
      return result.docs.map((doc) {
        var profileUser = ProfileUser.fromJson(doc.data());
        return profileUser;
      }).toList();
    } catch (e) {
      throw Exception("Error while Fetching users ....: $e");
    }
  }

  // Function to return the uid based on the email
  Future<String?> getUidByEmail(String email) async {
    try {
      print(email);
      // Query Firestore for the user document with the given email
      final querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: email)
          .get();

      // Check if any document is found
      if (querySnapshot.docs.isNotEmpty) {
        // Return the uid field from the first matching document
        final id = querySnapshot.docs.first.id as String?;
        print(id);
        return id;
      } else {
        return null; // No user found with the given email
      }
    } catch (e) {
      throw Exception("Error while fetching uid by email: $e");
    }
  }
}
