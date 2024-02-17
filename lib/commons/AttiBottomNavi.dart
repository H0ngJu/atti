import 'package:atti/screen/HomePatient.dart';
import 'package:atti/screen/memory/gallery/MainGallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/memory_yellow.svg',
          untappedIcon: 'lib/assets/icons/memory_white.svg',
          label: '내 기억',
          isSelected: currentIndex == 0,

        ),
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/camera_yellow.svg',
          untappedIcon: 'lib/assets/icons/camera_white.svg',
          label: '기억하기',
          isSelected: currentIndex == 1,
        ),
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/home_yellow.svg',
          untappedIcon: 'lib/assets/icons/home_white.svg',
          label: '홈',
          isSelected: currentIndex == 2,
        ),
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/routine_yellow.svg',
          untappedIcon: 'lib/assets/icons/routine_white.svg',
          label: '하루 일과',
          isSelected: currentIndex == 3,
        ),
        _buildBottomNavigationBarItem(
          tappedIcon: 'lib/assets/icons/schedule_yellow.svg',
          untappedIcon: 'lib/assets/icons/schedule_white.svg',
          label: '일정',
          isSelected: currentIndex == 4,
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
    } else if (index == 2) {
      Get.to(HomePatient());
    } else {
      onTap(index);
    }
  }
}
