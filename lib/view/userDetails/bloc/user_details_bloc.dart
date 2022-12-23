import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:meta/meta.dart';
import 'package:msa_software/model/user_detail.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

const throttleDuration = Duration(milliseconds: 1000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  UserDetailsBloc({required this.dio}) : super(const UserDetailsState()) {
    on<UserDetailFetched>(
      _onUserDetailFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final  Dio dio;

  Future<void> _onUserDetailFetched(
      UserDetailFetched event,
      Emitter<UserDetailsState> emit,
      ) async {
    try {
      if (state.status == UserDetailStatus.initial) {
        final userData = await _fetchUserDetail(event.userId);
        return emit(
          state.copyWith(
            status: UserDetailStatus.success,
            ///TODO: "as List<User>" is added for removing error////
             userData: userData,
          ),
        );
      }
      final userData = await _fetchUserDetail(event.userId);
    } catch (_) {
      emit(state.copyWith(status: UserDetailStatus.failure));
    }
  }

  Future<UserDetail> _fetchUserDetail(int userId) async {
    var response = await dio.get('users/$userId');
    if (response.statusCode == 200) {
      final body = response.data;
      final map = body as Map<String, dynamic>;
      return UserDetail(
        //  userId: map['id'] as int,
        name: map['name'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String,
        web: map['website'] as String,
        company: map['company']['name'] as String,
        street: map['address']['street'] as String,
        city: map['address']['city'] as String,
      );
      // return body.map((dynamic json) {
      //   print('aldjieowhjdfuhreuih');
      //   final map = json as Map<String, dynamic>;
      //   print('user detail name is ${map.toString()}');
      //   return UserDetail(
      //   //  userId: map['id'] as int,
      //     name: map['name'] as String,
      //     email: map['email'] as String,
      //     phone: map['phone'] as String,
      //     web: map['website'] as String,
      //     company: map['company']['name'] as String,
      //     street: map['address']['street'] as String,
      //     city: map['address']['city'] as String,
      //   );
      // });
    }
    throw Exception('error fetching posts');
  }

}