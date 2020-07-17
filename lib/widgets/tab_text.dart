import 'package:firebase/styleguide/text_styles.dart';
import 'package:flutter/material.dart';

class TabText extends StatelessWidget {
  final bool isSelected;
  final String text;
  Function onTabTap;
  TabText({this.text, this.isSelected, this.onTabTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTabTap();
      },
      child: Transform.rotate(
        angle: -1.58,
        child: AnimatedDefaultTextStyle(
            style: isSelected ? selectedTabStyle : defaultTabStyle,
            duration: const Duration(milliseconds: 500),
            child: Text(
              text,
            )),
      ),
    );
  }
}
