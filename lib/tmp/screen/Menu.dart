import 'package:atti/tmp/screen/HomePatient.dart';
import 'package:atti/tmp/screen/UserInfoEditPage.dart';

import '../../index.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final ColorPallet _colorPallet = ColorPallet();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('기억친구 아띠',
                      style: TextStyle(
                          fontFamily: 'UhBee', fontSize: 25
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePatient()),
                            (Route<dynamic> route) => false, // 모든 이전 페이지를 제거
                      );
                    },
                    child: Image.asset(
                      'lib/assets/images/xButton.png',
                      height: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '나의 정보',
                    style: TextStyle(fontSize: 24,
                    color: _colorPallet.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserInfoEditPage()),
                      );
                    },
                    child: Container(
                      width: 60, // 버튼의 너비
                      height: 27, // 버튼의 높이
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      child: const Center(
                        child: Text(
                          '수정',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(width*0.02),
                child: Column(
                  children: [
                    // 사이즈 박스를 두 개 뱌치하기
                    // 그 안에 줄 세우기
                    const SizedBox(height: 16),
                    _infoRow('이름', _authController.userName.value, width*0.43),
                    const SizedBox(height: 16),
                    _infoRow('생년월일', _authController.birthDate, width*0.43),
                    const SizedBox(height: 16),
                    _infoRow('가족 및\n친한 지인', _authController.familyMember.value.join('\n'), width*0.43),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
        
              // Text(
              //   '연결된 계정',
              //   style: TextStyle(fontSize: 24, color: _colorPallet.grey),
              // ),
              const SizedBox(height: 16),
              // _buildAccountRow('최한별', '박민정', '아이디 isldkd', '보호자'),
              // _buildAccountRow('김정연', '', '치매파트너', ''),
              const SizedBox(height: 32),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _authController.logout();
                  },
                  child: Container(
                    width: 111, // 버튼의 너비
                    height: 60, // 버튼의 높이
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: const Center(
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _authController.logout(); // 임의로 로그아웃되게 만듦
                  },
                    child: Center(
                      child: Text(
                        '회원탈퇴',
                        style: TextStyle(
                          color: _colorPallet.grey,
                          fontSize: 20,
                          decoration: TextDecoration.underline
                    ),
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        Text(value, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
  Widget _infoRow(String title, String value, double boxSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: boxSize,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24
            ),
          ),
        ), // width * 0.43
        SizedBox(
          width: boxSize,
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 24
            ),
          ),
        ),
      ],
    );
  }
}
