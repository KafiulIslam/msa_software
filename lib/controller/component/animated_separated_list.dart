import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../constant/constant_widget.dart';


class AnimatedListviewSeparated extends StatelessWidget {
  final List userList;
  final int itemCount;
  const AnimatedListviewSeparated({Key? key,required this.userList,required this.itemCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimationLimiter(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => primarySpacerVertical,
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: userList[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
