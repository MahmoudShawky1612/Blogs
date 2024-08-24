class Blog {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool saved;
  final String username;

  Blog({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.saved,
    required this.username,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    try {
      return Blog(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
        saved: json['saved'] ?? false,
        username: json['username'] ?? '',
      );
    } catch (e) {
      print('Error parsing Blog: $e');
      throw Exception('Error parsing Blog');
    }
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'saved': saved,
      'username': username,
    };
  }
}

class User {
  final String email;
  final String username;
  final String token;

  User({required this.email, required this.username, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'token': token,
    };
  }
}
