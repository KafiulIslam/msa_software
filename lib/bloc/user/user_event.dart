part of 'user_bloc.dart';

@immutable
abstract class UsersEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class UsersFetched extends UsersEvent {}

@immutable
abstract class UserDetailEvent extends Equatable{
  @override
  List<Object> get props => [];

}

class UserDetailFetched extends UserDetailEvent {

  UserDetailFetched({required this.userId});
  final int userId;
}