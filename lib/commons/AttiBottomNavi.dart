import 'package:atti/patient/screen/memory/gallery/MainMemory.dart';
import 'package:atti/tmp/screen/HomeCarer.dart';
import 'package:atti/patient/screen/HomePatient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../carer/screen/memory/gallery/CarerMainMemory.dart';
import '../carer/screen/routine_shcedule/CarerRoutineScheduleMain.dart';
import '../data/auth_controller.dart';
import '../patient/screen/routine_schedule/RoutineScheduleMain.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({super.key, required this.currentIndex, required this.onTap});

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
          tappedIcon: 'lib/assets/icons/memory_orange.svg',
          untappedIcon: 'lib/assets/icons/memory_black.svg',
          label: '내 기억',
          isSelected: currentIndex == 0,

        ),
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/home_orange.svg',
          untappedIcon: 'lib/assets/icons/home_black.svg',
          label: '홈',
          isSelected: currentIndex == 1,
        ),
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/RShome_orange.svg',
          untappedIcon: 'lib/assets/icons/RShome_black.svg',
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
    if (index == 0 && authController.isPatient) {
      Get.to(const MainMemory());
    } else if (index == 0 && !authController.isPatient) {
      Get.to(const CarerMainMemory());
    } else if (index == 1 && authController.isPatient ) {
      Get.to(const HomePatient());
    } else if(index == 1 && !authController.isPatient){
      Get.to(const HomeCarer());
    } else if (index == 2 && authController.isPatient) {
      Get.to(const RoutineScheduleMain());
    } else if (index == 2 && !authController.isPatient) {
      Get.to(const CarerRoutineScheduleMain());
    } else {
      onTap(index);
    }
  }
}
