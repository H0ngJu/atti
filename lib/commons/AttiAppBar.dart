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
    List<Widget> appBarActions = [];
    if (showPersonIcon) {
      appBarActions.add(
        Container(
          margin: EdgeInsets.only(right: 16),
          child : IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.person,
            color: Colors.grey,
            size: 40,
          ),
          ),
        ),
      );
    }
    appBarActions.addAll(actions ?? []);

    return PreferredSize(
      preferredSize: Size.fromHeight(412),
      child: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: title,
        leading: showNotificationsIcon
            ? Container(
          margin: EdgeInsets.only(left: 16),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              )
            : null,
        actions: appBarActions,
      ),
    );
  }
}
