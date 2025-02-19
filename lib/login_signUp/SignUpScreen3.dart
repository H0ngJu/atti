import 'package:atti/login_signUp/SignUpScreen4.dart';
import 'package:atti/index.dart';

class SignUpScreen3 extends StatefulWidget {
  const SignUpScreen3({super.key});

  @override
  State<SignUpScreen3> createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  final SignUpController _signUpController = Get.put(SignUpController());
  // final SignUpController _signUpController = Get.find<SignUpController>();
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final _formKey = GlobalKey<FormState>();

  User? loggedUser;
  DateTime userBirthDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    ColorPallet colorPallet = ColorPallet();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String inputBirthDate = '000000';

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            const DetailPageTitle(
              title: '본인인증',
              description: '',
              totalStep: 3,
              currentStep: 3,
            ),

            Container(
              margin: EdgeInsets.only(top: height * 0.2, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '생년월일을 입력해 주세요.',
                        style: TextStyle(
                          letterSpacing: 0.01,
                          fontSize: 24,
                          fontFamily: 'PretendardRegular',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height*0.01),
                        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, right: 7.0, left: 9.0),
                        decoration: BoxDecoration(
                          color: colorPallet.lightYellow,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: _signUpController.isPressed.value == 2 ? colorPallet.textColor : colorPallet.lightYellow,
                          ),
                        ),
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              _signUpController.isPressed.value = 2;
                            });
                            print("isPressed = ${_signUpController.isPressed.value}\nfieldId = ${2}");
                          },
                          onChanged: (value) {
                              setState(() {
                                inputBirthDate = value;
                                _signUpController.scrn3_isValid.value = inputBirthDate.length == 7;
                              });
                              if (inputBirthDate.length == 7 && int.tryParse(inputBirthDate) != null) {
                                print("len **************** ${inputBirthDate.length}");
                                String birthDateString = inputBirthDate.substring(0, 7);
                                int yearPrefix;
                                int year = int.parse(birthDateString.substring(0, 2));

                                if (year >= 0 && year <= 30) {
                                  yearPrefix = 2000;
                                } else {
                                  yearPrefix = 1900;
                                }

                                year += yearPrefix; // 기준 연도를 더함
                                int month = int.parse(birthDateString.substring(2, 4));
                                int day = int.parse(birthDateString.substring(4, 6));

                                userBirthDate = DateTime(year, month, day);

                                _signUpController.userBirthDate = userBirthDate;
                                int sex = int.parse(birthDateString.substring(6));
                                _signUpController.userSex.value = sex;
                                print("성별 : ${_signUpController.userSex.value}");
                                print("생일 : ${_signUpController.userBirthDate}");
                              }
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "000000  -  0●●●●●●",
                            hintStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.grey, // 원하는 색상으로 변경
                              fontFamily: 'PretendardRegular',
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height*0.01),
                        width: width*0.9,
                        // height: height*0.08,
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 7.0, left: 9.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5DB),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          _signUpController.userName.value,
                          style: const TextStyle(
                            letterSpacing: 0.01,
                            fontSize: 24,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                      NextBtn(
                        isButtonDisabled: !_signUpController.scrn3_isValid.value,
                        nextPage: const SignUpScreen4(),
                        buttonName: "확인",
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}