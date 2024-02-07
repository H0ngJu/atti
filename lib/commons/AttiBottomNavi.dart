import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        _buildBottomNavigationBarItem(
          icon: 'lib/assets/icons/memory.svg',
          label: '내 기억',
        ),
        _buildBottomNavigationBarItem(
          icon: 'lib/assets/icons/camera.svg',
          label: '기억하기',
        ),
        _buildBottomNavigationBarItem(
          icon: 'lib/assets/icons/home.svg',
          label: '홈',
        ),
        _buildBottomNavigationBarItem(
          icon: 'lib/assets/icons/routine.svg',
          label: '하루 일과',
        ),
        _buildBottomNavigationBarItem(
          icon: 'lib/assets/icons/schedule.svg',
          label: '일정',
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        height: 28,
      ),
      label: label,
    );
  }

  // 추가한 부분
  void _onItemTapped(int index) {
    onTap(index);
  }
}
