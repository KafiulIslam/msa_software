part of 'user_details_bloc.dart';


enum UserDetailStatus { initial, success, failure }

class UserDetailsState extends Equatable {
  const UserDetailsState({
    this.status = UserDetailStatus.initial,
    this.userData = const UserDetail(name: 'name', email: 'email', phone: 'phone', web: 'web', company: 'company', street: 'street', city: 'city'),
  });

  final UserDetailStatus status;
  final UserDetail userData;

  UserDetailsState copyWith({
    UserDetailStatus? status,
    UserDetail? userData,
  }) {
    return UserDetailsState(
      status: status ?? this.status,
      userData: userData!,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, userData: $userData }''';
  }

  @override
  List<Object> get props => [status, userData];
}

