import 'package:atti/data/notification/notification_controller.dart';
import 'package:atti/data/report/viewsController.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/screen/memory/chat/Chat.dart';
import 'package:atti/screen/memory/gallery/GalleryOption.dart';
import 'package:atti/screen/memory/gallery/RecollectionData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/memory/memory_note_model.dart';

class RecollectionDetail extends StatelessWidget {
  final RecollectionData data;

  const RecollectionDetail({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(title: '그때 그 시절'),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      '${data.img}',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.7,
                      //height: 150,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Text(
                    '${data.year}년대',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'PretendardRegular',
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '\'${data.title}\'',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'PretendardMedium',
                    ),
                  ),
                ),
                Divider(color: Color(0xffE1E1E1)),
                SizedBox(
                  height: 14,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('기억 정보', style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'PretendardRegular',)),
                    SizedBox(height: 15,),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        '${data.description}',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'PretendardRegular',
                            height: 2),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
