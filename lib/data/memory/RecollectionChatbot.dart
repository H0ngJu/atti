import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../data/report/emotion_controller.dart';

class RecollectionChatbot {
  //final firestore = FirebaseFirestore.instance;
  EmotionController emotionController = Get.put(EmotionController());

  Future<String> getResponse(var prompt, String img) async {
    await dotenv.load(fileName: '.env');
    final String apiKey = dotenv.env['GEMINI_API_KEY']!;

    final model = GenerativeModel(
      model: 'gemini-1.5-pro-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: 70,
        temperature: 0.7,
      ),
      requestOptions: const RequestOptions(apiVersion: 'v1beta'),
      systemInstruction: Content.text(
          '너는 치매 어르신과 대화를 나누는 보이스봇 아띠야. 어르신이 화면 속의 사진에 담긴 추억을 회상하는 것을 돕는 것이 목적이야. 너의 역할은 질문에 대한 정보를 제공하는 것이 아니야. 어르신께 사진에 대해 물어봐줘. 사진의 정보를 바탕으로 공감하고 긍정적인 정서를 이끌어내도록 어르신께 대화를 유도해줘. 그리고 너무 길게 말하지 말아줘.'
      ),
    );

    // 도큐먼트 조회하여 imgDescription 필드 값 가져오기
    //var documentSnapshot = await docRef.get();
    //var imgDescription = documentSnapshot['imgDescription'];

    // 채팅
    final chat = model.startChat(history: [
      Content.text("사진의 정보 : $img"),
      Content.model([TextPart('어르신, 어떤 날 찍은 사진인지 기억하시나요? 이 때의 기분은 어떠셨어요?')]),
    ]);

    var startTime = DateTime.now();
    var response = await chat.sendMessage(Content.text(prompt));
    var endTime = DateTime.now();
    print('챗봇 응답 생성 시간: ${endTime.difference(startTime)}');
    print(response.text);
    return response.text!;
  }

  // 감정 분석
  Future<void> emotionAnalysis(String messages) async {
    await dotenv.load(fileName: '.env');
    final String apiKey = dotenv.env['GEMINI_API_KEY']!;

    final model = GenerativeModel(
      model: 'gemini-1.5-pro-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: 70,
        temperature: 0.7,
      ),
      requestOptions: const RequestOptions(apiVersion: 'v1beta'),
      systemInstruction: Content.text(
          '이 대화에서 사용자가 느낀 감정들을 분석해줘. 기쁨, 그리움, 슬픔, 즐거움 이런 식으로 짧은 단어로 3~4개 정도 분석해줘.'
      ),
    );
    final content = [Content.text(messages)];
    final response = await model.generateContent(content);
    print(response.text);

    List<String> emotionsList = response.text!.split(',').map((e) => e.trim()).toList();
    emotionController.addEmotion(emotionsList);
  }
}