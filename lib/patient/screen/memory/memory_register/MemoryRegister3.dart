// 피그마 '기억하기3 - 연도, 가족 구성원 선택' 화면
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/Tag.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegisterAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/patient/screen/memory/memory_register/MemoryRegister4.dart';
import '../../../../data/auth_controller.dart';

class MemoryRegister3 extends StatefulWidget {
  const MemoryRegister3({super.key});

  @override
  State<MemoryRegister3> createState() => _MemoryRegister3State();
}

class _MemoryRegister3State extends State<MemoryRegister3> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());
  final AuthController authController = Get.put(AuthController());
  TextEditingController _addedMemberController = TextEditingController();

  final _era = ['1900년대', '1910년대', '1920년대', '1930년대', '1940년대', '1950년대',
    '1960년대', '1970년대', '1980년대', '1990년대', '2000년대', '2010년대', '2020년대',];
  String? _selectedEra;
  late List<String> familyMembers;
  late List<bool> memberIsSelected = [];
  late List<String> selectedMembers = [];

  late List<String> addedMember = [];

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ColorPallet _colorPallet = ColorPallet();

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            DetailPageTitle(
              title: '기억 남기기',
              totalStep: 3,
              currentStep: 2,
              description: '기억 연도를 선택해주세요',
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: width * 0.04,),
                  SelectEraDropDownButton(),
                  SizedBox(height: width * 0.08,),
                  Center(
                    child: Container(
                      //margin: EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.centerLeft,
                      child: Text('기억과 함께한 사람을 \n선택 및 입력해주세요',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            height: 1.2
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: width * 0.04,),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: SelectFamilyMemberButtons()),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: width*0.05),
                    child: Wrap(
                      spacing: 8.0,
                      children: addedMember.map((member) {
                        return Tag(
                          name: member,
                          fontsize: 24,
                          backgroundColor: _colorPallet.goldYellow,
                          onDelete: () {
                            setState(() {
                              addedMember.remove(member); // addedMember 리스트에서 삭제
                              selectedMembers.remove(member); // selectedMembers 리스트에서도 삭제
                              memoryNoteController.memoryNote.value.selectedFamilyMember = selectedMembers; // 상태 업데이트
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(width*0.05),
                    decoration: BoxDecoration(
                      color: _colorPallet.lightYellow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            //margin: EdgeInsets.symmetric(horizontal: width*0.05),
                            child: TextField(
                              controller: _addedMemberController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '그 외 사람을 입력하세요',
                                hintStyle: TextStyle(
                                    color: Color(0xff745C20),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: width * 0.16,
                          height: width * 0.09,
                          child: TextButton(
                            onPressed: () {
                              String memberName = _addedMemberController.text;
                              if (memberName.isNotEmpty) {
                                setState(() {
                                  addedMember.add(memberName);
                                  _addedMemberController.clear(); // 입력 필드 비우기

                                  selectedMembers.add(memberName);
                                  memoryNoteController.memoryNote.value.selectedFamilyMember = selectedMembers;
                                });
                              }

                            },
                            style: TextButton.styleFrom(
                              backgroundColor: _addedMemberController.text.isNotEmpty ? _colorPallet.goldYellow : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '등록',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

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
    ColorPallet _colorPallet = ColorPallet();
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
          child: Text(e,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              color: Colors.black),
          ),
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
              borderSide: BorderSide(color: _colorPallet.lightYellow, width: 2)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: _colorPallet.lightYellow, width: 1)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: _colorPallet.lightYellow, width: 2)
          ),

          filled: true,
          fillColor: _colorPallet.lightYellow,
          iconColor: _colorPallet.khaki,
          contentPadding: EdgeInsets.only(top:5, bottom: 5, left: 15),
        ),
        dropdownColor:_colorPallet.lightYellow,
        iconDisabledColor: _colorPallet.khaki,
        iconEnabledColor: _colorPallet.khaki,
        iconSize: 50,
      ),
    );
  }

  Widget SelectFamilyMemberButtons() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ColorPallet _colorPallet = ColorPallet();

    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 10, // 가로 간격 설정
      runSpacing: 12, // 세로 간격 설정
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
            textStyle: WidgetStateProperty.all<TextStyle>(
              TextStyle(fontSize: 24), // 텍스트 크기
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                return Colors.black;
              },
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                if (memberIsSelected[index]) {
                  return _colorPallet.goldYellow; // 선택됐을 때 배경색
                } else {
                  return Colors.white; // 선택되지 않았을 때 배경색
                }
              },
            ),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 5, horizontal: 15), // 버튼 내부 패딩 설정
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22), // 버튼 모서리 둥글기 설정
                side: BorderSide(
                  color: Colors.black, // 테두리 색상
                  width: 1, // 테두리 두께
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}