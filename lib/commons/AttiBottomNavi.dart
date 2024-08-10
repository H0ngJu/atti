import 'package:atti/screen/HomeCarer.dart';
import 'package:atti/screen/HomePatient.dart';
import 'package:atti/screen/memory/gallery/MainGallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../data/auth_controller.dart';
import '../screen/RoutineScheduleMain.dart';
import '../screen/memory/register/MemoryRegister1.dart';
import '../screen/routine/RoutineMain.dart';
import '../screen/schedule/ScheduleMain.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/memory_black.svg',
          untappedIcon: 'lib/assets/icons/memory_white.svg',
          label: '내 기억',
          isSelected: currentIndex == 0,

        ),
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/home_black.svg',
          untappedIcon: 'lib/assets/icons/home_white.svg',
          label: '홈',
          isSelected: currentIndex == 1,
        ),
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/RShome_black.svg',
          untappedIcon: 'lib/assets/icons/RShome_white.svg',
          label: '일과/일정',
          isSelected: currentIndex == 2,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String label,
    required bool isSelected,
    required String tappedIcon,
    required String untappedIcon,

  }) {
    return BottomNavigationBarItem(
      icon: isSelected
          ? SvgPicture.asset(
        tappedIcon,
        height: 28,
      )
          : SvgPicture.asset(
        untappedIcon,
        height: 28,
      ),
      label: label,
    );
  }

  // 추가한 부분
  void _onItemTapped(int index) {
    if (index == 0) {
      Get.to(MainGallery());
    } else if (index == 1 && authController.isPatient ) {
      Get.to(HomePatient());
    } else if(index == 1 && !authController.isPatient){
      Get.to(HomeCarer());
    }else if (index == 2) {
      Get.to(RoutineScheduleMain());
    } else {
      onTap(index);
    }
  }
}
