import 'package:flutter/material.dart';
import 'package:msa_software/controller/constant/constant_widget.dart';
import '../../view/userDetails/user_details.dart';
import '../constant/typography.dart';

class UserInfoCard extends StatelessWidget {
  final String? userName, email, phone, city;
  final int? userId;

  const UserInfoCard({Key? key,this.userName,this.email, this.phone, this.city,this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (_)=> UserDetails(userId: userId!)));
      },
      child: Card(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          _infoTile('Name',userName!),
          eightVerticalSpace,
          _infoTile('Email',email!),
          eightVerticalSpace,
          _infoTile('Phone',phone!),
          eightVerticalSpace,
          _infoTile('City',city!),
        ],),
      ),),
    );
  }

Widget  _infoTile(String title,String info,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          Text(title,style: sixteenDeepAssStyle,),
          Text(info,style: sixteenDeepAssStyle,),
      ],);
}

}
