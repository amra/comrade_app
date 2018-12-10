class User {
  final String username;
  final String first_name;
  final String last_name;
  final String email;

  User(this.username, this.first_name, this.last_name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        first_name = json['first_name'],
        last_name = json['last_name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
      };
}
