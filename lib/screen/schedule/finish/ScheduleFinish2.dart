// 피그마 '일정 완료하기 2' 화면
import 'package:atti/screen/HomePatient.dart';
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    margin: EdgeInsets.only(left: 15),
                    //alignment: Alignment.centerLeft,
                    child: Text('\'추후 수정\' 기억을\n내 기억에 남길까요?',
                      style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w500
                    ),),
                  ),
                  //SizedBox(width: 10,),
                  Container(
                    //margin: EdgeInsets.only(left: 50),
                    child: Image.asset('lib/assets/images/mini_atti.png',
                      width: MediaQuery.of(context).size.width * 0.2,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
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
                    MaterialPageRoute(builder: (context) => HomePatient()),
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
