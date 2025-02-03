import 'package:flutter/material.dart';

class CarerRoutineModal extends StatelessWidget {
  const CarerRoutineModal({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      backgroundColor: Colors.white,

      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Color(0xffB8B8B8),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                )
              ],
            ),
            SizedBox(height: 5, width: width * 0.8,),
             Container(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 30),
                )),
            SizedBox(height: height * 0.01,),
            Text(
              '이번달 일과 완료율',
              style: TextStyle(fontSize: 24),
            ),

          ],
        ),
      ),
    );
  }
}


