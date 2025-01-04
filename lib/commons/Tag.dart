import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  // 태그 위젯: 텍스트와 삭제 아이콘으로 구성된 태그 스타일 위젯
  final String name; // 태그 이름 (텍스트)
  final Color backgroundColor; // 태그 배경색 (기본값: 흰색)
  final double fontsize; // 태그 글자 크기 (기본값: 16)
  final VoidCallback onDelete; // 삭제 아이콘 클릭 시 실행될 함수

  Tag({
    required this.name,
    this.backgroundColor = Colors.white,
    this.fontsize = 16,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 태그 컨테이너의 여백 설정
      margin: fontsize != 16
          ? EdgeInsets.only(top: 12) // 기본 글자 크기가 아닌 경우 위쪽 여백 12
          : EdgeInsets.symmetric(vertical: 5), // 기본 글자 크기일 경우 위아래 여백 5
      height: fontsize + 20, // 태그 높이: 글자 크기 + 14
      padding: fontsize != 16
          ? EdgeInsets.fromLTRB(12, 0, 8, 0) // 기본 글자 크기가 아닌 경우 좌우 여백 10
          : EdgeInsets.symmetric(horizontal: 5), // 기본 글자 크기일 경우 좌우 여백 5
      decoration: BoxDecoration(
        color: backgroundColor, // 태그 배경색 설정
        border: Border.all(color: Colors.black), // 태그 테두리: 검정색
        borderRadius: BorderRadius.circular(30), // 둥근 테두리: 반지름 30
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 태그 컨텐츠의 너비를 최소화 (컨텐츠에 맞춤)
        children: [
          // 태그 이름 텍스트
          Text(
            name, // 전달받은 태그 이름 표시
            style: TextStyle(fontSize: fontsize), // 글자 크기 설정
          ),
          SizedBox(
            width: fontsize != 16 ? 10 : 3, // 텍스트와 구분선 사이 간격
          ),
          // 태그 안의 구분선 (세로선)
          Container(
            height: fontsize + 20, // 구분선 높이: 태그 높이와 동일
            child: VerticalDivider(
              width: 1, // 구분선의 너비
              thickness: 1, // 구분선의 두께
              color: Colors.black, // 구분선 색상: 검정색
            ),
          ),
          SizedBox(
            width: fontsize != 16 ? 5 : 1, // 구분선과 닫기 아이콘 사이 간격
          ),
          // 닫기 아이콘 (삭제 버튼)
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close, // 닫기 아이콘
              size: fontsize != 16 ? 24 : 18, // 아이콘 크기
              color: Colors.black, // 아이콘 색상: 검정색
            ),
          ),
        ],
      ),
    );
  }
}

