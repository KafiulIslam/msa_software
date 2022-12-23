part of 'user_details_bloc.dart';

@immutable
abstract class UserDetailsEvent extends Equatable{
  @override
  List<Object> get props => [];

}

class UserDetailFetched extends UserDetailsEvent {

  UserDetailFetched({required this.userId});
  final int userId;
}

