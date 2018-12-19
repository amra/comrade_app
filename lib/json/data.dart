import 'package:comrade_app/json/user.dart';

class Data {
    List<User> colleges;

    Data(this.colleges);

    Data.fromJson(Map<String, dynamic> json) : colleges = (json['colleges'] as List).map((i) => User.fromJson(i)).toList();

    Map<String, dynamic> toJson() =>
            {
                'colleges': colleges,
            };
}
