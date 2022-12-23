import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:msa_software/controller/constant/constant_widget.dart';
import '../../controller/api/dio.dart';
import '../../controller/api/user_info_api.dart';
import '../../controller/component/loader.dart';
import '../../controller/constant/color.dart';
import '../../controller/constant/typography.dart';
import 'bloc/user_details_bloc.dart';

class UserDetails extends StatelessWidget {
  final int? userId;

  const UserDetails({Key? key, this.userId}) : super(key: key);

  _phoneCall(String phone) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phone);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'User Details',
            style: header2,
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: BlocProvider(
          create: (_) => UserDetailsBloc(dio: dio)..add(UserDetailFetched(userId: userId!)),
          child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
            builder: (context, state) {
              if(state.status == UserDetailStatus.failure){
                return const Center(child: Text('Failed to load user information'));
              }else if (state.status == UserDetailStatus.success){
                final data = state.userData ;
                return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _profile(data.name, '${data.street}, ${data.city}'),
                          SizedBox(
                            height: screenHeight / 16,
                          ),
                          _infoTile(Icons.email, 'Email', data.email, () async {
                            await FlutterEmailSender.send(Email(
                              body: 'Hi ${data.name},\nHappy New Year',
                              subject: 'Greetings!',
                              recipients: [data.email],
                            ));
                          }),
                          _infoTile(Icons.phone, 'Phone', data.phone, () {
                          _phoneCall(data.phone);
                          }),
                          _infoTile(Icons.web, 'Website', data.web, null),
                          _infoTile(Icons.business, 'Company Name', data.company, null),
                        ],
                      ),
                    ),
                  ),
                );
              }else{
                return const Loader();
              }
            },
          ),
        )

        );
  }

  Widget _profile(String name, String address) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 52,
          backgroundColor: lightBlue,
          child: CircleAvatar(
            backgroundColor: assColor,
            radius: 50,
            child: Icon(
              Icons.person,
              color: iconColor,
              size: 40,
            ),
          ),
        ),
        eightVerticalSpace,
        Text(name, style: sixteenBlackStyle),
        Text(
          address,
          style: fourteenBlackStyle,
        )
      ],
    );
  }

  Widget _infoTile(
      IconData icon, String title, String info, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: lightBlue,
                child: Icon(
                  icon,
                  size: 20,
                  color: primaryColor,
                ),
              ),
              primarySpacerHorizontal,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: fourteenDeepAssStyle,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    info,
                    style: sixteenBlackStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
