import 'dart:typed_data';

abstract class StorageRepo {
  // uploading profile Image on mobile Platform
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // uploading profileImage on web platform
  Future<String?> uploadProfilleImageWeb(Uint8List fileBytes, String fileName);

  // uploading post Image on mobile Platform
  Future<String?> uploadPostImageMobile(String path, String fileName);

  // uploading post iamge on web platform
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName);
}
