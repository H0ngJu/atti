import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GalleryOption(),
    );
  }
}

class GalleryOption extends StatefulWidget {
  const GalleryOption({Key? key}) : super(key: key);

  @override
  State<GalleryOption> createState() => _GalleryOptionState();
}

class _GalleryOptionState extends State<GalleryOption> {
  final List<String> tagList = [
    '최근',
    '최한별',
    '박수정',
    '박시목',
    '밥',
    '김명자',
    '복순이',
    '회상하지 않은 사진',
    '기타',
    '기타1',
    '기타2'
  ];
  late String selectedTag = '';
  late bool showAllTags;

  @override
  void initState() {
    super.initState();
    selectedTag = tagList.first;
    showAllTags = tagList.length <= 6;
  }

  Widget CurrentTag() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            '현재 단어',
            style: TextStyle(fontSize: 24),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Color(0xffD9D9D9), borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Text(
            '옛날',
            style: TextStyle(fontSize: 24, color: Color(0xff616161)),
          ),
        )
      ],
    );
  }

  Widget NewTag() {
    return Column(
      children: [
        Container(
          child: Text(
            '변경할 단어',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('기억 순서 변경'),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                        text: '어떤 기억 단어로\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                      text: '사진을 다시 나열할까요?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                        text: '\n아래에서 선택해 주세요',
                        style: TextStyle(fontSize: 24, color: Color(0xff9F9F9F))),
                  ],
                ),
              ),
            ),
            Container(margin: EdgeInsets.all(16), child: CurrentTag()),
            Container(
              margin: EdgeInsets.all(16),
              child: NewTag(),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15),
                child: SelectFamilyMemberButtons()),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFFC215),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 48),
                    ),
                    child: Text(
                      '사진 나열하기',
                      style: TextStyle(color: Colors.white),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget SelectFamilyMemberButtons() {
    List<String> displayTags = showAllTags ? tagList : tagList.take(6).toList();

    return Column(
      children: [
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 10,
          // 가로 간격 설정
          runSpacing: 10,
          // 세로 간격 설정
          children: List.generate(displayTags.length, (index) {
            return TextButton(
              onPressed: () {
                setState(() {
                  selectedTag = displayTags[index];
                });
              },
              child: Text(displayTags[index]),
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(fontSize: 24, inherit: true), // inherit 속성 추가
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                    if (displayTags[index] == selectedTag) {
                      return Colors.white; // 선택됐을 때 텍스트 색상
                    } else {
                      return Color(0xffA38130); // 선택되지 않았을 때 텍스트 색상
                    }
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                    if (displayTags[index] == selectedTag) {
                      return Color(0xffFFC215); // 선택됐을 때 배경색
                    } else {
                      return Color(0xffFFF5DB); // 선택되지 않았을 때 배경색
                    }
                  },
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(vertical: 10, horizontal: 18.0), // 버튼 내부 패딩 설정
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // 버튼 모서리 둥글기 설정
                  ),
                ),
              ),
            );
          }),
        ),
        // 토글 버튼 추가
        if (tagList.length > 6)
          TextButton(
            onPressed: () {
              setState(() {
                showAllTags = !showAllTags;
              });
            },
            child: Icon(
              showAllTags ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.blue,
              size: 30,
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.zero,
              ),
            ),
          ),
      ],
    );
  }
}
