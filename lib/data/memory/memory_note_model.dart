import 'package:cloud_firestore/cloud_firestore.dart';

/// patientId : "patientId"
/// img : "imgUrl"
/// imgTitle : "돌잔치"
/// era : "2000년대"
/// chat : [{"content":"무슨 사진인가요?","speaker":"아띠","time":"2022-10-09T08:00:00.000Z"},{"content":"손주 돌잔치 때였지","speaker":"사용자","time":"2022-10-09T08:00:00.000Z"}]
/// selectedFamilyMember : {"첫째딸":true,"남편":false}
/// keyword : ["돌잔치","딸집","한복"]
/// createdAt : "2022-10-09T08:00:00.000Z"

class MemoryNoteModel {
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
  MemoryNoteModel(
      {this.patientId,
      this.img,
      this.imgTitle,
      this.era,
      this.chat,
      this.selectedFamilyMember,
      this.keyword,
      this.createdAt,
      this.reference});

  // json -> object (Firestore -> Flutter)
  MemoryNoteModel.fromJson(dynamic json, this.reference) {
    patientId = json['patientId'];
    img = json['img'];
    imgTitle = json['imgTitle'];
    era = json['era'] is int
        ? json['era']
        : int.tryParse(json['era'] ?? ''); // 수정된 부분
    chat = json['chat'];
    //print("JSON received: $json");
    selectedFamilyMember = json['selectedFamilyMember'];
    keyword = json['keyword'] != null ? List<String>.from(json['keyword']) : [];
    createdAt = json['createdAt'];
    reference = json['reference'];
  }

  // Named Constructor with Initializer
  // snapshot 자료가 들어오면 이걸 다시 Initializer를 통해 fromJson Named Constructor를 실행함
  MemoryNoteModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  // Named Constructor with Initializer
  // 컬렉션 내에 특정 조건을 만족하는 데이터를 다 가지고 올때 사용
  MemoryNoteModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  // object -> json (Flutter -> Firebase)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['patientId'] = patientId;
    map['img'] = img;
    map['imgTitle'] = imgTitle;
    map['era'] = era;
    map['chat'] = chat;
    map['selectedFamilyMember'] = selectedFamilyMember;
    map['keyword'] = keyword;
    map['createdAt'] = createdAt;
    map['reference'] = reference;
    return map;
  }

  @override
  String toString() {
    return '''
MemoryNoteModel(
  patientId: $patientId,
  img: $img,
  imgTitle: $imgTitle,
  era: $era,
  chat: $chat,
  selectedFamilyMember: $selectedFamilyMember,
  keyword: $keyword,
  createdAt: $createdAt,
  reference: $reference
)
''';
  }
}
