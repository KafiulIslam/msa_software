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

class UserDetail extends Equatable {
  const UserDetail(
      {required this.name,
        required this.email,
        required this.phone,
        required this.web,
        required this.company,
        required this.street,
        required this.city});

  final String name;
  final String email;
  final String phone;
  final String web;
  final String company;
  final String street;
  final String city;

  @override
  List<Object> get props => [name, email, phone, web, company, street, city];
}

