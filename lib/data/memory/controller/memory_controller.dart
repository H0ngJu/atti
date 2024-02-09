import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MemoryNote {
  late String? id;
  late Map<String, dynamic>? chat;
  late Timestamp? createdAt;
  late String? era;
  late String? img;
  late String? imgTitle;
  late String? patientId;
  late Map<String, dynamic>? selectedFamilyMember;
  late DocumentReference reference;

  MemoryNote({
    this.id,
    this.chat,
    this.createdAt,
    this.era,
    this.img,
    this.imgTitle,
    this.patientId,
    this.selectedFamilyMember,
    required this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'chat': chat,
      'createdAt': createdAt,
      'era': era,
      'img': img,
      'imgTitle': imgTitle,
      'patientId': patientId,
      'selectedFamilyMember': selectedFamilyMember,
    };
  }

//   MemoryNote.fromSnapshot(DocumentSnapshot snapshot)
//       : id = snapshot.id,
//         chat = snapshot.data()?['chat'],
//         createdAt = snapshot.data()?['createdAt'],
//         era = snapshot.data()?['era'],
//         img = snapshot.data()?['img'],
//         imgTitle = snapshot.data()?['imgTitle'],
//         patientId = snapshot.data()?['patientId'],
//         selectedFamilyMember = snapshot.data()?['selectedFamilyMember'],
//         reference = snapshot.reference;
// }
}
