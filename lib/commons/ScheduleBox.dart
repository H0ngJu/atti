// 일정 박스 UI (시간, 이름, 장소)
// 사용법 :
// ScheduleBox(
//                   time: scheduleController.time.value,
//                   name: scheduleController.name.value,
//                   location: scheduleController.location.value,
//                 ),
import 'package:atti/index.dart';
import 'package:intl/intl.dart';

import '../patient/screen/routine_schedule/CustomModal.dart';

class ScheduleBox extends StatefulWidget {
  final Function onCompleted; // 콜백 함수 추가

  const ScheduleBox(
      {super.key,
        this.time,
        this.name,
        this.location,
        required this.isFinished,
        this.docRef,
        required this.isEditMode,
        required this.onCompleted,
      });

  final DateTime? time;
  final String? name;
  final String? location;
  final bool isFinished;
  final DocumentReference? docRef;
  final bool isEditMode;

  @override
  State<ScheduleBox> createState() => _ScheduleBoxState();
}

class _ScheduleBoxState extends State<ScheduleBox> {
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final AuthController authController = Get.put(AuthController());

  // 일정 시간이 지났는지 판단하는 헬퍼 메서드
  bool _scheduleTimePassed() {
    if (widget.time != null) {
      return DateTime.now().isAfter(widget.time!);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            // 완료용 토글 버튼
            widget.isEditMode
            ? GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => CustomModal(
                        title: '\'${widget.name}\'\n일정을 삭제할까요?',
                        yesButtonColor: colorPallet.orange,
                        onYesPressed: () async {
                          await ScheduleService().deleteSchedule(widget.docRef!);
                          widget.onCompleted(); // 콜백 함수 호출

                          Navigator.pop(context); // 모달창 닫기
                        },
                        onNoPressed: () {
                          Navigator.pop(context);
                        })
                );
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colorPallet.orange,
                  shape: BoxShape.circle
                ),
                child: const Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 15
                  ),
                ),
              ),
            )
            : GestureDetector(
              onTap: () {
                if (!widget.isFinished) { // 완료여부 false일때만 동작
                  showDialog(
                      context: context,
                      builder: (_) {
                        return CustomModal(
                          title: authController.isPatient
                          ? '\'${widget.name}\'\n일정을 완료하셨나요?' // 환자일 때
                          : '${authController.patientName}님이\n\'${widget.name}\'\n일정을 완료하셨나요?', // 보호자일 때
                          yesButtonColor: colorPallet.orange,
                          onYesPressed: () async {
                            await ScheduleService().completeSchedule(widget.docRef!);

                            await addNotification(
                                '일정 알림',
                                '${authController.userName}님이 \'${widget.name}\' 일정을 완료하셨어요!',
                                DateTime.now(),
                                false);

                            Navigator.pop(context);

                            showDialog(
                              context: context,
                              builder: (_) => CustomModal(
                                title: "'${widget.name}'을\n내 기억에 남길까요?",
                                yesButtonColor: colorPallet.goldYellow,
                                onYesPressed: () {
                                  Get.to(const MemoryRegister1());
                                },
                                onNoPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RoutineScheduleFinish(
                                        name: widget.name,
                                        category: 'schedule',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );

                          },
                          onNoPressed: () {
                            Navigator.pop(context);
                          },
                        );
                      });
                }
              },
              child: CustomPaint(
                painter: DottedCirclePainter(),
                child: Container(
                  width: width * 0.12,
                  height: width * 0.12,
                  alignment: Alignment.center,
                  child: widget.isFinished
                  ? const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 30,
                  )
                    : _scheduleTimePassed()
                      ? const Icon(
                        Icons.close,
                        color: Color(0xffFF6200),
                        size: 30
                      )
                      : null,
                ),
              ),
            ),

            SizedBox(width: width * 0.06,),

            // 일정 시간
            Container(
              decoration: BoxDecoration(
                color: widget.isEditMode ? colorPallet.lightGrey : Colors.transparent,
                borderRadius: BorderRadius.circular(15), // 외곽선을 15만큼 둥글게
              ),
              padding: widget.isEditMode
                  ? const EdgeInsets.fromLTRB(8, 7, 8, 7)
                  : EdgeInsets.zero,
              child: Text(
                DateFormat('a hh:mm', 'ko_KR').format(widget.time!) ?? '-',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            widget.isEditMode ? SizedBox(width: width * 0.03,) : SizedBox(width: width * 0.08),

            // 일정 제목
            Expanded( // Row 내부에서 텍스트를 유연하게 줄이기 위해 Expanded 사용
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isEditMode ? colorPallet.lightGrey : Colors.transparent,
                  borderRadius: BorderRadius.circular(15), // 외곽선을 15만큼 둥글게
                ),
                padding: widget.isEditMode
                    ? const EdgeInsets.fromLTRB(8, 7, 8, 7)
                    : EdgeInsets.zero,
                child: Text(
                  widget.name ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                  overflow: TextOverflow.ellipsis, // overflow 발생 시 ... 표시
                  maxLines: 1, // 한 줄로 제한
                  softWrap: false, // 텍스트 줄바꿈 비활성화
                ),
              ),
            ),
          ],
        ));
  }
}

// 점선 외곽선 Painter
class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double radius = size.width / 2;
    double dashWidth = 4; // 점선의 길이
    double dashSpace = 2; // 점선 사이의 간격

    var circumference = 2 * 3.14159265359 * radius; // 원의 둘레
    int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    double anglePerDash = (3.14159265359 * 2) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      double startAngle = i * anglePerDash;
      double endAngle = startAngle + dashWidth / radius;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}