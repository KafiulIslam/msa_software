import 'package:flutter/material.dart';
import 'package:msa_software/controller/component/user_info_card.dart';
import 'package:msa_software/controller/constant/color.dart';
import 'package:msa_software/controller/constant/typography.dart';
import '../../controller/api/user_info_api.dart';
import '../../controller/component/animated_separated_list.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<UserInfoCard> userList = [];

  Future<void> loadUserInfo() async {
    final countryData = await getUserInfo();
    countryData['data'].forEach((element) {
      late int userId = element['id'] ?? 1;
      late String name = element['name'] ?? '';
      late String email = element['email'] ?? '';
      late String phone = element['phone'] ?? '';
      late String city = element['address']['city']?? '';
      setState(() {
        userList.add(UserInfoCard(userName: name,email: email,phone: phone,city: city,userId: userId,));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }
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
      body: AnimatedListviewSeparated(userList: userList,itemCount: userList.length,),
    );
  }
}
