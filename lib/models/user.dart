class User {
  final String? id;
  final String telephone;

  const User({
    this.id,
    required this.telephone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      telephone: json['telephone']?.toString() ?? '',
    );
  }
}
