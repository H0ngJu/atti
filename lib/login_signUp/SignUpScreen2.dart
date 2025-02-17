import 'package:atti/index.dart';
import 'package:atti/login_signUp/SignUpScreen3.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final SignUpController _signUpController = Get.put(SignUpController());
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final _formKey = GlobalKey<FormState>();

  User? loggedUser;
  DateTime userBirthDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    ColorPallet colorPallet = ColorPallet();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isValid = _signUpController.userName.value.length > 1;

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
                        '이름을 입력해 주세요.',
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
                            color: _signUpController.isPressed.value == 1 ? colorPallet.textColor : colorPallet.lightYellow,
                          ),
                        ),
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              _signUpController.isPressed.value = 1;
                            });
                            print("isPressed = ${ _signUpController.isPressed.value}\nfieldId = ${1}");
                          },
                          onChanged: (value) => _signUpController.userName.value = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "이름",
                            hintStyle: TextStyle(
                              fontSize: 24,
                              color: colorPallet.textColor,
                              fontFamily: 'PretendardRegular',
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                      NextBtn(
                        isButtonDisabled: !isValid,
                        nextPage: const SignUpScreen3(),
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