import 'package:atti/index.dart';

final ColorPallet colorPallet = Get.put(ColorPallet());

class RegisterTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;

  const RegisterTextField({
    Key? key,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.black,
        style: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 24,
            color: colorPallet.khaki, // khaki 색상
            fontWeight: FontWeight.w400
          ),
          filled: true, // 배경을 채움
          fillColor: const Color(0xffFFF5DB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(15), // 위아래 여백 조절
        ),
      ),
    );
  }
}
