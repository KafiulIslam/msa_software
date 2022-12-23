import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {required this.userId,
      required this.name,
      required this.email,
      required this.phone,
      required this.city});

  final int userId;
  final String name;
  final String email;
  final String phone;
  final String city;

  @override
  List<Object> get props => [userId, name, email, phone, city];
}
