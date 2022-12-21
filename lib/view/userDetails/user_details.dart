import 'package:flutter/material.dart';
import '../../controller/api/user_info_api.dart';
import '../../controller/constant/color.dart';
import '../../controller/constant/typography.dart';

class UserDetails extends StatefulWidget {
  final int? userId;

  const UserDetails(
      {Key? key, this.userId})
      : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  late String name = '';
  late String email = '';
  late String phone = '';
  late String web = '';
  late String company = '';

  Future<void> loadUserDetails() async {
    final countryData = await getUserDetails(widget.userId!);
    setState(() {
      name = countryData['data']['name'] ?? '';
      email = countryData['data']['email'] ?? '';
      phone = countryData['data']['phone'] ?? '';
      web = countryData['data']['website'] ?? '';
      company = countryData['data']['company']['name'] ?? '';
    });
    print('name is 1 %%% $name');
    print('name is 2 %%% $email');
    print('name is 3 %%% $phone');
    print('name is 4 %%% $web');
    print('name is 5 %%% $company');
//     countryData['data'].forEach((element) {
//        name = element['name'] ?? '';
//        email = element['email'] ?? '';
//        phone = element['phone'] ?? '';
//        web = element['website'] ?? '';
//        company = element['company']['name'] ?? '';
// print('kdjoiewj ****  1 $name, 2 $email 3 $phone 4 $web 5 $company');
//       // setState(() {
//       //   userList.add(UserInfoCard(userName: name,email: email,phone: phone,city: city,));
//       // });
//     });
  }

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'User Details',
            style: header2,
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            TextButton(onPressed: (){loadUserDetails();}, child: Text('trila'))
          ],
        ));
  }

  Widget _infoTile(
    String title,
    String info,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: sixteenBlackStyle,
        ),
        Text(
          info,
          style: sixteenBlackStyle,
        ),
      ],
    );
  }
}
