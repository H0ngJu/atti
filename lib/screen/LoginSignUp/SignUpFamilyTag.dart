import 'package:atti/commons/colorPallet.dart';
import 'package:atti/data/signup_login/SignUpController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_tag_editor/tag_editor.dart';

class SignUpFamilyTag extends StatefulWidget {
  const SignUpFamilyTag({super.key});

  @override
  State<SignUpFamilyTag> createState() => _SignUpFamilyTagState();
}

class _SignUpFamilyTagState extends State<SignUpFamilyTag> {
  final SignUpController signUpController = Get.put(SignUpController());
  ColorPallet _colorPallet = ColorPallet();
  List<String> _values = [];

  onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(
                  child : AddKeywordTag(),
              ),
            ),
          ],
        ),
      );
  }

  Widget AddKeywordTag() {
    final ColorPallet colorPallet = Get.put(ColorPallet());
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TagEditor(
          tagSpacing: 10,
          length: _values.length,
          delimiters: [',', ' '],
          hasAddButton: false,
          textStyle: TextStyle(fontSize: 20),
          inputDecoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: _colorPallet.lightYellow, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: _colorPallet.textColor, width: 1)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: _colorPallet.lightYellow, width: 1)
              ),
              contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 15),
              filled: true,
              fillColor: _colorPallet.lightYellow,
              hintText: '가족 구성원을 입력해주세요',
              hintStyle: TextStyle(color: Color(0xffA38130), fontSize: 24, fontWeight: FontWeight.normal)
          ),

          onTagChanged: (newValue) {
            setState(() {
              _values.add(newValue);
              // memoryNoteController.memoryNote.value.keyword = _values;
              signUpController.userFamily.value = _values;
            });
          },
          tagBuilder: (context, index) => _Chip(
            index: index,
            label: _values[index],
            onDeleted: onDelete,
          )
      ),
    );
  }

}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5,),
      child: Chip(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xffA38130), width: 1),
            borderRadius: BorderRadius.circular(20)
        ),
        labelPadding: const EdgeInsets.only(left: 5.0, right: 5),
        label: Text(label, style: TextStyle(
            fontSize: 20, color: Color(0xffA38130), fontWeight: FontWeight.normal
        ),),
        padding: EdgeInsets.all(5),
        deleteIcon: const Icon(
          Icons.close,
          size: 18,
          color: Color(0xffA38130),
        ),
        onDeleted: () {
          onDeleted(index);
        },
      ),
    );
  }
}