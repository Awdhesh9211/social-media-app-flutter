import 'package:mediasocial/entities/models/app_user.dart';

abstract class AuthRepo {
  
  // login
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  // signup
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password);
  // logout 
  Future<void> logout();
  // get current User 
  Future<AppUser?> getCurrenUser();
}
