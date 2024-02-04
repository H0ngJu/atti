import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final bool showNotificationsIcon;
  final bool showPersonIcon;

  AttiAppBar({
    this.title,
    this.actions,
    this.showNotificationsIcon = true,
    this.showPersonIcon = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: title,
      actions: <Widget>[
        if (showNotificationsIcon)
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              )),
        if (showPersonIcon)
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ))
      ]..addAll(actions ?? []),
    );
  }
}
