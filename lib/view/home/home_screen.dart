import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msa_software/controller/api/dio.dart';
import 'package:msa_software/controller/component/loader.dart';
import 'package:msa_software/controller/component/user_info_card.dart';
import 'package:msa_software/controller/constant/color.dart';
import 'package:msa_software/controller/constant/typography.dart';
import 'package:msa_software/view/home/bloc/users_bloc.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: header2,
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: BlocProvider(
        create: (_) => UsersBloc(dio: dio)..add(UsersFetched()),
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if(state.status == UsersStatus.failure){
              return const Center(child: Text('Failed to load Users List'));
            }else if (state.status == UsersStatus.success){
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8.0,),
                  itemBuilder: (BuildContext context, int index) {
                    var data = state.users[index];
                    return UserInfoCard(
                      userName: data.name,
                      email: data.email,
                      phone: data.phone,
                      city: data.city,
                      userId: data.userId,
                    );
                  },
                  itemCount: state.users.length,
                  //  controller: _scrollController,
                ),
              );
            }else{return const Loader();}
          },
        ),
      ),
    );
  }
}
