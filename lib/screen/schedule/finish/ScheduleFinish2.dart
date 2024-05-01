// 피그마 '일정 완료하기 2' 화면
import 'package:atti/screen/memory/register/MemoryRegister1.dart';
import 'package:flutter/material.dart';
import '../../RoutineScheduleMain.dart';
import '../ScheduleMain.dart';


class ScheduleFinish2 extends StatelessWidget {
  const ScheduleFinish2({super.key, required this.name});
  final name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(left: 15),
                //alignment: Alignment.centerLeft,
                child: Text('\'${name}\' 일정을\n내 기억에 남길까요?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w500
                ),),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
              Container(
                //margin: EdgeInsets.only(left: 50),
                alignment: Alignment.center,
                child: Image.asset('lib/assets/Atti/standingAtti.png',
                  width: MediaQuery.of(context).size.width * 0.8,
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
                    MaterialPageRoute(builder: (context) => RoutineScheduleMain()),
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
