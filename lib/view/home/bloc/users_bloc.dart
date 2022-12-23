import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../model/users_model.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

part 'users_event.dart';
part 'users_state.dart';

const throttleDuration = Duration(milliseconds: 1000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({required this.dio}) : super(const UsersState()) {
    on<UsersFetched>(
      _onUsersFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final  Dio dio;

  Future<void> _onUsersFetched(
      UsersFetched event,
      Emitter<UsersState> emit,
      ) async {
    try {
      if (state.status == UsersStatus.initial) {
        final users = await _fetchUsers();
        return emit(
          state.copyWith(
            status: UsersStatus.success,
            ///TODO: "as List<User>" is added for removing error////
            users: users as List<User>,
          ),
        );
      }
      final users = await _fetchUsers();
      users.isEmpty
          ? emit(state.copyWith())
          : emit(
        state.copyWith(
          status: UsersStatus.success,

          ///TODO: as List<User> is added for removing error////
          users: List.of(state.users)..addAll(users as List<User>),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: UsersStatus.failure));
    }
  }

  Future<List<dynamic>> _fetchUsers() async {
    var response = await dio.get('users');
    if (response.statusCode == 200) {
      final body = response.data as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return User(
          userId: map['id'] as int,
          name: map['name'] as String,
          email: map['email'] as String,
          phone: map['phone'] as String,
          city: map['address']['city'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}