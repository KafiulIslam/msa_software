import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:msa_software/controller/constant/constant_widget.dart';
import '../../controller/api/user_info_api.dart';
import '../../controller/constant/color.dart';
import '../../controller/constant/typography.dart';

class UserDetails extends StatefulWidget {
  final int? userId;

  const UserDetails({Key? key, this.userId}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late String name = '';
  late String email = '';
  late String phone = '';
  late String web = '';
  late String company = '';
  late String street = '';
  late String city = '';

  Future<void> loadUserDetails() async {
    final countryData = await getUserDetails(widget.userId!);
    setState(() {
      name = countryData['data']['name'] ?? '';
      email = countryData['data']['email'] ?? '';
      phone = countryData['data']['phone'] ?? '';
      web = countryData['data']['website'] ?? '';
      company = countryData['data']['company']['name'] ?? '';
      street = countryData['data']['address']['street'] ?? '';
      city = countryData['data']['address']['city'] ?? '';
    });
  }

  _phoneCall(String phone) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phone);
  }

  @override
  void initState() {
    super.initState();
    loadUserDetails();
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
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _profile(name, '$street, $city'),
                  SizedBox(
                    height: screenHeight / 16,
                  ),
                  _infoTile(Icons.email, 'Email', email, () async {
                    await FlutterEmailSender.send(Email(
                      body: 'Hi $name,\nHappy New Year',
                      subject: 'Greetings!',
                      recipients: [email],
                    ));
                  }),
                  _infoTile(Icons.phone, 'Phone', phone, () {
                    _phoneCall(phone);
                  }),
                  _infoTile(Icons.web, 'Website', web, null),
                  _infoTile(Icons.business, 'Company Name', company, null),
                ],
              ),
            ),
          ),
        ));
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
