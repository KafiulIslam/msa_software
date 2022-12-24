part of 'user_bloc.dart';

enum UsersStatus { initial, success, failure }

class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
    this.statusMessage = '',
    this.users = const <User>[],
  });

  final UsersStatus status;
  final String statusMessage;
  final List<User> users;

  UsersState copyWith({
    UsersStatus? status,
    String? statusMessage,
    List<User>? users,
  }) {
    return UsersState(
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage,
      users: users ?? this.users,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, users: ${users.length} }''';
  }

  @override
  List<Object> get props => [status, users];
}


enum UserDetailStatus { initial, success, failure }

class UserDetailState extends Equatable {
  const UserDetailState({
    this.status = UserDetailStatus.initial,
    this.statusMessage = '',
    this.userData = const UserDetail(name: '', email: '', phone: '', web: '', company: '', street: '', city: ''),
  });

  final UserDetailStatus status;
  final String statusMessage;
  final UserDetail userData;

  UserDetailState copyWith({
    UserDetailStatus? status,
    String? statusMessage,
    UserDetail? userData,
  }) {
    return UserDetailState(
        status: status ?? this.status,
        statusMessage: statusMessage ?? this.statusMessage,
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
