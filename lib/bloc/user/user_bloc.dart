import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../controller/api/dio.dart';
import '../../model/user.dart';

part 'user_event.dart';

part 'user_state.dart';

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

  final Dio dio;

  Future<void> _onUsersFetched(
      UsersFetched event, Emitter<UsersState> emit) async {
    try {
      final users = await _fetchUsers();

      if ( users['status'] == 'success' ) {
        return emit(
          state.copyWith(
            status: UsersStatus.success,
            statusMessage: 'Users successfully loaded',
            users: users['data'],
          ),
        );
      } else {
        return emit(
          state.copyWith(
            status: UsersStatus.failure,
            statusMessage: users['data']['non_field_errors'],
            users: [],
          ),
        );
      }
    } catch (_) {
      print(_);
      emit(state.copyWith(
          status: UsersStatus.failure, statusMessage: 'Something went wrong'));
    }
  }

  Future<Map<String, dynamic>> _fetchUsers() async {
    try {
      var response = await dio.get('users');

      return {
        'status': 'success',
        'data': response.data.map<User>((user) {
          return User(
            userId: user['id'] as int,
            name: user['name'] as String,
            email: user['email'] as String,
            phone: user['phone'] as String,
            city: user['address']['city'] as String,
          );
        }).toList()
      };
    } on DioError catch (e) {
      return getErrorResponse(e);
    }
  }
}

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  UserDetailBloc({required this.dio}) : super(const UserDetailState()) {
    on<UserDetailFetched>(
      _onUserDetailFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final Dio dio;

  Future<void> _onUserDetailFetched(
    UserDetailFetched event,
    Emitter<UserDetailState> emit,
  ) async {
    try {
      final userData = await _fetchUserDetail(event.userId);
      if (userData['status'] == 'success') {
        return emit(
          state.copyWith(
            status: UserDetailStatus.success,
            statusMessage: 'Users successfully loaded',
            userData: userData['data'],
          ),
        );
      } else {
        return emit(
          state.copyWith(
            status: UserDetailStatus.failure,
            statusMessage: userData['data']['non_field_errors'],
            userData: userData['data'],
          ),
        );
      }
    } catch (_) {
      print(_);
      emit(state.copyWith(
          status: UserDetailStatus.failure,
          statusMessage: 'Something went wrong'));
    }
  }

  Future<Map<String, dynamic>> _fetchUserDetail(int userId) async {
    try {
      var response = await dio.get('users/$userId');
      var data = response.data;
      return {
        'status': 'success',
        'data': UserDetail(
          name: data['name'] as String,
          email: data['email'] as String,
          phone: data['phone'] as String,
          web: data['website'] as String,
          company: data['company']['name'] as String,
          street: data['address']['street'] as String,
          city: data['address']['city'] as String,
        )
      };
    } on DioError catch (e) {
      return getErrorResponse(e);
    }
  }
}
