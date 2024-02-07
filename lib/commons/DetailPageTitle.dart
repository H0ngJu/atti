// 상세 페이지 윗부분 (뒤로가기 아이콘, 제목과 설명, 진행도)
// 사용법 :
// DetailPageTitle(
//                   title: '일정 등록하기',
//                   description: '일정 이름을 입력해주세요',
//                   totalStep: 6,
//                   currentStep: 1,
//                 ),

import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPageTitle extends StatefulWidget {
  const DetailPageTitle({super.key, this.title, this.description, this.totalStep, this.currentStep});
  final title;
  final description;
  final totalStep;
  final currentStep;

  @override
  State<DetailPageTitle> createState() => _DetailPageTitleState();
}

class _DetailPageTitleState extends State<DetailPageTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container( // 뒤로가기 아이콘
                    //margin: EdgeInsets.only(top: 50, left: 5),
                    child: IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.arrow_back_ios_outlined, size: 25))),
                //SizedBox(height: 30.0),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(widget.title, style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500
                  ),),
                ),

                if (widget.totalStep != 0)
                Container(
                  margin: EdgeInsets.only(right: 15),
                  width: 12.toDouble() * widget.totalStep,
                  child: StepProgressIndicator(
                    totalSteps: widget.totalStep,
                    currentStep: widget.currentStep,
                    size: 6,
                    padding: 3,
                    selectedColor: Color(0xffFFC215),
                    unselectedColor: Color(0xffCDCDCD)
                  ),
                )
                else SizedBox(width: 60,),
              ],
            ),
          ),
          SizedBox(height: 40,),
          Container(
            //width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(left: 15),
            child: Text(widget.description, style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w600
            ),),
          ),
          //SizedBox(height: 30.0),

        ],
      ),
    );
  }
}
