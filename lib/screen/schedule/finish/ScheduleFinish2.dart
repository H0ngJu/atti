// 피그마 '일정 완료하기 2' 화면
import 'package:atti/screen/schedule/finish/RegisterNo.dart';
import 'package:atti/screen/memory/register/MemoryRegister1.dart';
import 'package:flutter/material.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';


class ScheduleFinish2 extends StatelessWidget {
  const ScheduleFinish2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Column(
            children: [
              DetailPageTitle(
                title: '일정 완료하기',
                description: '\'마을회관 방문\'을 \n내 기억으로 남길까요?',
                totalStep: 0,
                currentStep: 0,
              ),
              SizedBox(height: 80,),
              Container(
                //margin: EdgeInsets.only(left: 30),
                child: Image.asset('lib/assets/images/hurrayatti.png',
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          )),

          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            child: Row(
              children: [
                TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemoryRegister1()),
                  );
                }, child: Text('네', style: TextStyle(color: Colors.white, fontSize: 20),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
                    minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width * 0.43, 50)),
                  ),), SizedBox(width: MediaQuery.of(context).size.width * 0.04,),
                TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterNo()),
                  );
                }, child: Text('아니요', style: TextStyle(color: Color(0xffA38130), fontSize: 20),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xffFFF5DB)),
                    minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width * 0.43, 50)),
                  ),),
              ],
            ),
          ),
        ],
      )
    );
  }
}
