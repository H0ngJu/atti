import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/report/emotion_controller.dart';

// ==============================================================================
// Generative AI used part (Gemini)
class Chatbot {
  final firestore = FirebaseFirestore.instance;
  EmotionController emotionController = Get.put(EmotionController());

  Stream<String> getResponse(var prompt, DocumentReference docRef) async* {
    await dotenv.load(fileName: '.env');
    final String apiKey = dotenv.env['GEMINI_API_KEY']!;
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-pro-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: 70,
        temperature: 0.7,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high)
      ],
      requestOptions: RequestOptions(apiVersion: 'v1beta'),
      systemInstruction: Content.text(
          '''
          You are Ati, a voice bot that interacts with an elderly person with dementia.
          You speak only in Korean. Your goal is to help the elderly person recall memories from the photos on the screen.
          Your role is not to provide information in response to questions.
          You ask the elderly person questions about the photos.
          Use the information in the photo to guide the conversation in an empathetic and positive way to elicit emotions.
          And don't talk too long.
          '''
      ),
    );

    // 도큐먼트 조회하여 imgDescription 필드 값 가져오기
    var documentSnapshot = await docRef.get();
    var imgDescription = documentSnapshot['imgDescription'];

    // 채팅
    final chat = model.startChat(history: [
      Content.text("사진의 정보 : ${imgDescription}"),
      Content.model([TextPart('어르신, 어떤 날 찍은 사진인지 기억하시나요? 이 때의 기분은 어떠셨어요?')]),
    ]);

    var startTime = DateTime.now();
    var response = await chat.sendMessageStream(Content.text(prompt));
    var endTime = DateTime.now();
    print('챗봇 응답 생성 시간: ${endTime.difference(startTime)}');
    await for (final chunk in response) {
      print(chunk.text);
      yield chunk.text!;
    }
  }

  // 감정 분석
  Future<void> emotionAnalysis(String messages) async {
    await dotenv.load(fileName: '.env');
    final String apiKey = dotenv.env['GEMINI_API_KEY']!;
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-pro-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: 10,
        temperature: 0.7,
      ),
      requestOptions: RequestOptions(apiVersion: 'v1beta'),
      systemInstruction: Content.text(
          '''
          Analyze the emotions you felt in this conversation. For example, joy, longing, sadness, happiness, pleasure, and so on.
          Only keywords about emotions, and only in Korean.
          First example: joy, pleasure, and pride
          Second example: pleasure, longing, excitement 
          '''
      ),
    );
    final content = [Content.text(messages)];
    final response = await model.generateContent(content);
    print(response.text);

    List<String> emotionsList = response.text!.split(',').map((e) => e.trim()).toList();
    emotionController.addEmotion(emotionsList);
  }

  // 그때그시절 대화용 함수
  Stream<String> getRecollectionResponse(var prompt, String description) async* {
    await dotenv.load(fileName: '.env');
    final String apiKey = dotenv.env['GEMINI_API_KEY']!;
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-pro-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: 100,
        temperature: 0.7,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high)
      ],
      requestOptions: RequestOptions(apiVersion: 'v1beta'),
      systemInstruction: Content.text(
          '''
          You are Ati, a voice bot that converses with an elderly person with dementia. You must speak only in Korean. 
          Your purpose is to help the elderly person recall memories about a topic. 
          Your role is not to provide information about the question.
          Based on the information I give you about the topic, ask them how they were, what happened back then, etc.
          Empathize with the senior and try to elicit positive emotions.
          And don't talk too long.
          '''
      ),
    );

    // 채팅
    final chat = model.startChat(history: [
      Content.text("주제 : ${description}"),
      Content.model([TextPart('어르신, 혹시 이때가 기억나시나요? 이것과 관련된 기억에 남는 일이 있으시다면 말씀해주세요.')]),
    ]);

    var startTime = DateTime.now();
    var response = await chat.sendMessageStream(Content.text(prompt));
    var endTime = DateTime.now();
    print('챗봇 응답 생성 시간: ${endTime.difference(startTime)}');
    await for (final chunk in response) {
      print(chunk.text);
      yield chunk.text!;
    }
  }


}

// 너는 치매 어르신과 대화를 나누는 보이스봇 아띠야.
// 한국어로만 말해야해. 어르신이 화면 속의 사진에 담긴 추억을 회상하는 것을 돕는 것이 목적이야.
// 너의 역할은 질문에 대한 정보를 제공하는 것이 아니야. 어르신께 사진에 대해 물어봐줘.
// 사진의 정보를 바탕으로 공감하고 긍정적인 정서를 이끌어내도록 어르신께 대화를 유도해줘.
// 그리고 너무 길게 말하지 말아줘.

// 너는 치매 어르신과 대화를 나누는 보이스봇 아띠야. 한국어로만 말해야해.
// 너의 목적은 어르신과 함께 주제에 대한 추억을 회상하는 것을 돕는 거야.
// 너의 역할은 질문에 대한 정보를 제공하는 것이 아니야.
// 내가 주는 주제의 정보를 바탕으로, 그 시절엔 어떻게 지냈고 어떤 일이 있었는지 등을 물어봐줘.
// 어르신께 공감하고 긍정적인 정서를 이끌어내도록 유도해줘.
// 그리고 너무 길게 말하지 말아줘.