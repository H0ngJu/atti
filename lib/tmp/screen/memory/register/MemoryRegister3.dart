// 피그마 '기억하기3 - 연도, 가족 구성원 선택' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister4.dart';
import '../../../../data/auth_controller.dart';

class MemoryRegister3 extends StatefulWidget {
  const MemoryRegister3({super.key});

  @override
  State<MemoryRegister3> createState() => _MemoryRegister3State();
}

class _MemoryRegister3State extends State<MemoryRegister3> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());
  final AuthController authController = Get.put(AuthController());

  final _era = ['1900년대', '1910년대', '1920년대', '1930년대', '1940년대', '1950년대',
    '1960년대', '1970년대', '1980년대', '1990년대', '2000년대', '2010년대', '2020년대',];
  String? _selectedEra;
  late List<String> familyMembers;
  late List<bool> memberIsSelected = [];
  late List<String> selectedMembers = [];

  int eraStringToInt(String era) {
    return int.parse(era.replaceAll('년대', ''));
  }

  @override
  void initState() {
    super.initState();
    familyMembers = authController.familyMember;
    setState(() {
      _selectedEra = _era[12];
      memoryNoteController.memoryNote.value.era = eraStringToInt(_selectedEra!);
      memberIsSelected = List.generate(familyMembers.length, (index) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailPageTitle(
                    title: '기억하기',
                    description: '\'${memoryNoteController.memoryNote.value.imgTitle}\' 사진에 대한 정보를 알려주세요!',
                    totalStep: 4, currentStep: 3,
                  ),
                  SizedBox(height: 30,),

                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text('사진의 연도를 선택해주세요', textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 24,
                    ),),
                  ),
                  SizedBox(height: 10,),
                  SelectEraDropDownButton(),

                  SizedBox(height: 35,),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text('사진 속 가족 구성원을 선택해주세요', textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 24,
                    ),),
                  ),
                  SizedBox(height: 10,),

                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: SelectFamilyMemberButtons()),
                  SizedBox(height: 30,),
                ],
              ),
            )),
            BottomNextButton(next: MemoryRegister4(), content: '다음', isEnabled: true),
          ],
        ),
      ),
    );
  }

  Widget SelectEraDropDownButton() {
    return Container(
      //alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 15),
      width: MediaQuery.of(context).size.width * 0.5,
      child: DropdownButtonFormField(
        menuMaxHeight: 250,
        value: _selectedEra,
        items: _era
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: Color(0xffA38130)),),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedEra = value!;
            memoryNoteController.memoryNote.value.era = eraStringToInt(_selectedEra!);
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xffFFF5DB), width: 2)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xffA38130), width: 1)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xffFFF5DB), width: 2)
          ),
          filled: true,
          fillColor: Color(0xffFFF5DB),
          iconColor: Color(0xffA38130),
          contentPadding: EdgeInsets.only(top:5, bottom: 5, left: 15),
        ),
        dropdownColor: Color(0xffFFF5DB),
        iconDisabledColor: Color(0xffA38130),
        iconEnabledColor: Color(0xffA38130),
        iconSize: 50,
      ),
    );
  }

  Widget SelectFamilyMemberButtons() {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 10, // 가로 간격 설정
      runSpacing: 10, // 세로 간격 설정
      children: List.generate(familyMembers.length, (index) {
        return TextButton(
          onPressed: () {
            setState(() {
              memberIsSelected[index] = !memberIsSelected[index];
              if (memberIsSelected[index]) {
                selectedMembers.add(familyMembers[index]);
                memoryNoteController.memoryNote.value.selectedFamilyMember = selectedMembers;
                print(memoryNoteController.memoryNote.value.selectedFamilyMember);
              } else {
                selectedMembers.remove(familyMembers[index]);
                memoryNoteController.memoryNote.value.selectedFamilyMember = selectedMembers;
                print(selectedMembers);
              }
            });
          },
          child: Text(familyMembers[index]),
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(fontSize: 24), // 텍스트 크기
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                if (memberIsSelected[index]) {
                  return Colors.white; // 선택됐을 때 텍스트 색상
                } else {
                  return Color(0xffA38130); // 선택되지 않았을 때 텍스트 색상
                }
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                if (memberIsSelected[index]) {
                  return Color(0xffFFC215); // 선택됐을 때 배경색
                } else {
                  return Color(0xffFFF5DB); // 선택되지 않았을 때 배경색
                }
              },
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 10, horizontal: 18.0), // 버튼 내부 패딩 설정
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25), // 버튼 모서리 둥글기 설정
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}