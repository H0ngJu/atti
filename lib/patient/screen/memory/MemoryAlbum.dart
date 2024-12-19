import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:atti/patient/screen/memory/AddButton.dart';
import 'package:atti/tmp/screen/memory/gallery/MemoryDetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemoryAlbum extends StatelessWidget {
  final List<MemoryNoteModel> group;
  final String memoryKey;

  const MemoryAlbum({Key? key, required this.memoryKey, required this.group})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "$memoryKey\n기억모음"),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio:
                        0.8,
                  ),
                  itemCount: group.length,
                  itemBuilder: (context, index) {
                    final groupedMemory = group[index];
                    return GestureDetector(
                      onTap: () => Get.to(MemoryDetail(memory: groupedMemory)),
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Column(children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Column(children: [
                                  Image.network(
                                    groupedMemory.img ?? '',
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height:
                                        MediaQuery.of(context).size.width * 0.4,
                                    fit: BoxFit.cover,
                                  ),
                                ])),
                            Text(
                              groupedMemory.imgTitle ?? '',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontFamily: 'PretendardRegular'),
                            ),
                          ])),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            right: 0,
            child: AddButton())
      ]),
    );
  }
}
