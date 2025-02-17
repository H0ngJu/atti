import 'package:atti/tmp/screen/Notice/NoticeMain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../tmp/screen/Menu.dart';

class AttiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final bool showNotificationsIcon;
  final bool showMenu;

  const AttiAppBar({super.key, 
    this.title,
    this.actions,
    this.showNotificationsIcon = true,
    this.showMenu = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarActions = [];
    if (showNotificationsIcon) {
      appBarActions.add(
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: IconButton(
            onPressed: () {
              Get.to(const NoticeMain());
            },
            icon: const Icon(
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
      preferredSize: const Size.fromHeight(412),
      child: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: title,
        leading: showMenu
        ? Container(
          margin: const EdgeInsets.only(right: 16),
          child : IconButton(
            onPressed: () {
              Get.to(const Menu());
            },
            icon: const Icon(
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
