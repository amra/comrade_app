class User extends Comparable<User> {
    final String username;
    final String first_name;
    final String last_name;
    final String email;
    final String phone;
    final String company;
    final String department;
    final String location;
    final String workforce_id;
    final String cost_center;

    User({this.username = "", this.first_name = "", this.last_name = "", this.email = "", this.phone = "", this.company = "", this.department = "",
        this.location = "", this.workforce_id = "", this.cost_center = ""});

    User.fromJson(Map<String, dynamic> json)
            : username = json['username'],
                first_name = json['first_name'] ?? "",
                last_name = json['last_name'] ?? "",
                email = json['email'] ?? "",
                phone = json['phone'] ?? "",
                company = json['company'] ?? "",
                department = json['department'] ?? "",
                location = json['location'] ?? "",
                workforce_id = json['workforce_id'] ?? "",
                cost_center = json['cost_center'] ?? ""
    ;

    Map<String, dynamic> toJson() =>
            {
                'username': username,
                'first_name': first_name,
                'last_name': last_name,
                'email': email,
                'phone': phone,
                'company': company,
                'department': department,
                'location': location,
                'workforce_id': workforce_id,
                'cost_center': cost_center,
            };

    @override
    int compareTo(User other) {
        if (last_name == other.last_name) {
            return first_name.compareTo(other.first_name);
        }
        return last_name.compareTo(other.last_name);
    }

}
