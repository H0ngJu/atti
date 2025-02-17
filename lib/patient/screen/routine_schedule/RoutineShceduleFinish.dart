import 'package:atti/index.dart';

class RoutineScheduleFinish extends StatelessWidget {
  const RoutineScheduleFinish({super.key,
    required this.name,
    required this.category
  });
  final name;
  final category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF9EB),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset('lib/assets/images/finish_atti.png'),
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(left: 15),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '\'$name\'\n',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: category == 'schedule'
                            ? '일정을 완료했어요!'
                            : '일과를 완료했어요!', // category에 따라 다른 텍스트
                        style: const TextStyle(
                          fontSize: 44, // 텍스트 크기
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left, // 텍스트 정렬 (필요시 변경 가능)
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                Get.to(const RoutineScheduleMain());
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                minimumSize: WidgetStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.9, 50)),
              ),
              child: const Text('일과/일정으로 돌아가기', style: TextStyle(color: Colors.black, fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }
}
