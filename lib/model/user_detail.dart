import 'package:equatable/equatable.dart';

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
  List<Object> get props => [ name, email, phone,web, company,street, city];
}
