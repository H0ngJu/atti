import 'package:atti/screen/Notice/NoticeMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../screen/Menu.dart';

class AttiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final bool showNotificationsIcon;
  final bool showMenu;

  AttiAppBar({
    this.title,
    this.actions,
    this.showNotificationsIcon = true,
    this.showMenu = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarActions = [];
    if (showNotificationsIcon) {
      appBarActions.add(
        Container(
          margin: EdgeInsets.only(left: 16),
          child: IconButton(
            onPressed: () {
              Get.to(NoticeMain());
            },
            icon: Icon(
              Icons.notifications,
              color: Colors.grey,
              size: 40,
            ),
          ),
        )
      );
    }
    appBarActions.addAll(actions ?? []);

    return PreferredSize(
      preferredSize: Size.fromHeight(412),
      child: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: title,
        leading: showMenu
        ? Container(
          margin: EdgeInsets.only(right: 16),
          child : IconButton(
            onPressed: () {
              Get.to(Menu());
            },
            icon: Icon(
              Icons.menu,
              color: Colors.grey,
              size: 40,
            ),
          ),
        ) : null ,
        actions: appBarActions,
      ),
    );
  }
}
