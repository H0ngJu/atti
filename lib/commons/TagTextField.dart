import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TagTextField extends StatefulWidget {
  const TagTextField({Key? key}) : super(key: key);

  @override
  State<TagTextField> createState() => _TagTextFieldState();
}

class _TagTextFieldState extends State<TagTextField> {
  late double _distanceToField;
  late TextfieldTagsController _controller; // 태그 컨트롤러인듯!!!

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            SizedBox(height: 100,),
            TextFieldTags(
              textfieldTagsController: _controller,
              // initialTags: const [ // 초기 태그들!!
              //   'pick',
              //   'your',
              //   'favorite',
              //   'programming',
              //   'language'
              // ],
              textSeparators: const [' ', ','], // 태그 나누는 구분자
              letterCase: LetterCase.normal, // 입력 텍스트 대소문자 제어. 손대지 않는다는 옵션
              // validator: (String tag) {
                // if (tag == 'php') { // 유효성 테스트인데 입력을 필수로 할지 고민
                //   return 'No, please just no';
                // }
                // return null;
              // },
              inputfieldBuilder:
                  (context, tec, fn, error, onChanged, onSubmitted) {
                return ((context, sc, tags, onTagDelete) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: tec,
                      focusNode: fn,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        // border: const OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Color.fromARGB(255, 74, 137, 92),
                        //     width: 3.0,
                        //   ),
                        // ),
                        // focusedBorder: const OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Color.fromARGB(255, 74, 137, 92),
                        //     width: 3.0,
                        //   ),
                        // ),
                        helperText: '예) 홍길동 김영희 (띄어쓰기 또는 , 기호)',
                        helperStyle: const TextStyle(
                          color: Color(0xffB3B3B3),
                          fontSize: 18,
                        ),
                        hintText: _controller.hasTags ? '' : "가족의 이름을 입력하세요. ",
                        hintStyle: TextStyle(
                          color: Color(0xffB3B3B3),
                          fontSize: 30
                        ),
                        errorText: error,
                        prefixIconConstraints:
                        BoxConstraints(maxWidth: _distanceToField * 0.9, maxHeight: 200),
                        prefixIcon: tags.isNotEmpty
                            ? SingleChildScrollView(
                          controller: sc,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: tags.map((String tag) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                    color: Color(0xffB3B3B3),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          ' $tag ',
                                          style: const TextStyle(
                                            fontSize: 24,
                                              color: Colors.white),
                                        ),
                                        // onTap: () {
                                        //   print("$tag selected");
                                        // },
                                      ),
                                      const SizedBox(width: 4.0),
                                      InkWell(
                                        child: const Icon(
                                          Icons.close,
                                          size: 24.0,
                                          color: Color.fromARGB(
                                              255, 233, 233, 233),
                                        ),
                                        onTap: () {
                                          onTagDelete(tag);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }).toList()),
                        )
                            : null,
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    ),
                  );
                });
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xffB3B3B3),
                ),
              ),
              onPressed: () {
                _controller.clearTags();
              },
              child: const Text('모두 삭제',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white
              ),),
            ),
          ],
        ),
      );
  }
}