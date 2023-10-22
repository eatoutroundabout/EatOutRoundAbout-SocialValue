import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final Function? onTap;
  final Color? backgroundColor;
  final double? marginBottom;

  const CustomListTile({this.leading, this.title, this.trailing, this.onTap, this.backgroundColor, this.marginBottom});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Colors.white,
      child: ListTile(
        onTap:()=> onTap!(),
        leading: leading,
        title: title,
        trailing: trailing,
      ),
      elevation: 1,
    );
  }
}
