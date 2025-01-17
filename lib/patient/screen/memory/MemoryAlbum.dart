import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:atti/patient/screen/memory/AddButton.dart';
import 'package:atti/patient/screen/memory/MemoryInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commons/AttiBottomNavi.dart';

class MemoryAlbum extends StatefulWidget {
  final List<MemoryNoteModel> group;
  final String memoryKey;

  const MemoryAlbum({Key? key, required this.memoryKey, required this.group})
      : super(key: key);

  @override
  _MemoryAlbumState createState() => _MemoryAlbumState();
}

class _MemoryAlbumState extends State<MemoryAlbum> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: "${widget.memoryKey}년대\n기억모음",
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: width * 0.9,
              child: Column(
                children: [
                  Expanded(
                    child: widget.group.length > 5
                        ? _buildGroupedMemoryCards()
                        : _buildGridView(context),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.2,
            right: 0,
            child: AddButton(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.8,
      ),
      itemCount: widget.group.length,
      itemBuilder: (context, index) {
        final groupedMemory = widget.group[index];
        return _buildMemoryCard(context, groupedMemory);
      },
    );
  }

  Widget _buildGroupedMemoryCards() {
    return ListView.builder(
      itemCount: (widget.group.length / 5).ceil(), // 5개씩 묶기
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, blockIndex) {
        final startIndex = blockIndex * 5;
        final endIndex = (startIndex + 5 <= widget.group.length)
            ? startIndex + 5
            : widget.group.length; // 남은 4개 아이템
        final currentGroup = widget.group.sublist(startIndex, endIndex);

        return Column(
          children: [
            if (currentGroup.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: _buildBigMemoryCard(context, currentGroup[0]),
              ),
            if (currentGroup.length > 1)
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: currentGroup.length - 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, gridIndex) {
                  final groupedMemory = currentGroup[gridIndex + 1];
                  return _buildMemoryCard(context, groupedMemory);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildMemoryCard(BuildContext context, MemoryNoteModel groupedMemory) {
    return GestureDetector(
      onTap: () => Get.to(MemoryInfo(memory: groupedMemory, albumList: widget.group)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              groupedMemory.img ?? '',
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.width * 0.45,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              groupedMemory.imgTitle ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'PretendardRegular',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigMemoryCard(BuildContext context, MemoryNoteModel groupedMemory) {
    return GestureDetector(
      onTap: () => Get.to(MemoryInfo(memory: groupedMemory, albumList: widget.group)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              groupedMemory.img ?? '',
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.4,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            groupedMemory.imgTitle ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'PretendardRegular',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
