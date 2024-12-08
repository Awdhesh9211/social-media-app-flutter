class AppUser {
  final String uid;
  final String email;
  final String name;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
  });

  // convert user -> json
  Map<String, dynamic> toJson() => {"uid": uid,"email": email,"name": name};

  // convert json -> user
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) => AppUser(uid: jsonUser['uid'],email: jsonUser['email'],name: jsonUser['name'],);

}
