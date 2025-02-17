import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/tmp/screen/memory/chat/RecollectionChat.dart';
import 'package:atti/data/memory/RecollectionData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RecollectionModel {
  // 자료형
  DocumentReference? patientId;
  String? img;
  String? imgTitle;
  int? era;
  String? chat;
  Map<String, dynamic>? selectedFamilyMember;
  List<String>? keyword;
  Timestamp? createdAt;
  DocumentReference? reference; // document 식별자

  // 생성자
  RecollectionModel({
    this.patientId,
    this.img,
    this.imgTitle,
    this.era,
    this.chat,
    this.selectedFamilyMember,
    this.keyword,
    this.createdAt,
    this.reference
  });
}

class RecollectionDetail extends StatelessWidget {
  final RecollectionData data;

  const RecollectionDetail({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: const SimpleAppBar(
            title: '그때 그 시절',
        ),
        body: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        data.img,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.55,
                        //height: 150,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                      '${data.year}년대',
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: 'PretendardRegular',
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      '\'${data.title}\'',
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'PretendardMedium',
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xffE1E1E1)),
                  const SizedBox(
                    height: 14,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('기억 정보',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'PretendardRegular',
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: const Color(0xffF3F3F3),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          data.description,
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'PretendardRegular',
                              height: 2),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.12,)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // 버튼 클릭 이벤트
                  Get.to(RecollectionChat(recollection: data));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0, // 버튼의 그림자를 제거
                  backgroundColor: const Color(0xffFFC215),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50), // 버튼의 크기 설정
                ),
                child: const Text(
                  '회상 대화 시작하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PretendardMedium',
                      fontSize: 24),
                ),
              ),
            ),
          ),
        ]));
  }
}
