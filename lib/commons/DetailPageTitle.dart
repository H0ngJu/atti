// 상세 페이지 윗부분 (뒤로가기 아이콘, 제목과 설명, 진행도)

import 'package:flutter/material.dart';

class DetailPageTitle extends StatefulWidget {
  const DetailPageTitle(
      {super.key,
      required this.title,
      this.description,
      required this.totalStep,
      required this.currentStep});

  final title;
  final String? description;
  final totalStep;
  final currentStep;

  @override
  State<DetailPageTitle> createState() => _DetailPageTitleState();
}

class _DetailPageTitleState extends State<DetailPageTitle> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(top: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 뒤로가기 아이콘
              SizedBox(
                  width: width * 0.048,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_outlined, size: 25))),
              //SizedBox(height: 30.0),

              // 상단바 제목
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                width: width * 0.13,
              )
            ],
          ),
        ),

        // 진행도 바
        if (widget.totalStep != 0)
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              width: width * 0.41,
              height: 6,
              // LinearProgressIndicator의 높이와 동일하게 설정
              decoration: BoxDecoration(
                color: const Color(0xffE9E9E9), // 미선택된 색상
                borderRadius: BorderRadius.circular(3), // 둥근 모서리 설정
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3), // 진행도 바 모서리 둥글게
                child: LinearProgressIndicator(
                  value: widget.currentStep / widget.totalStep, // 진행률 계산
                  backgroundColor: Colors.transparent, // 배경 투명
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xffFFC215)), // 선택된 색상
                ),
              ),
            ),
          )
        else
          const SizedBox(width: 60,),

        // 설명
        if (widget.description != null) ...[
          SizedBox(height: width * 0.06,),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.description!,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w500, height: 1.2),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}
