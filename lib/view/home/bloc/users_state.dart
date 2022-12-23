part of 'users_bloc.dart';

enum UsersStatus { initial, success, failure }

class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
     this.users = const <User>[],
  });

  final UsersStatus status;
    final List<User> users;

  UsersState copyWith({
    UsersStatus? status,
    List<User>? users,
  }) {
    return UsersState(
      status: status ?? this.status,
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
