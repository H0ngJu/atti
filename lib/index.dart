// 공통
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// 파이어베이스 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 패키지 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:material_tag_editor/tag_editor.dart';

// commons ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
import 'package:atti/commons/AttiAppBar.dart';
import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/ErrorMessageWidget.dart';
import 'package:atti/commons/FinishScreen.dart';
import 'package:atti/commons/RoutineBox.dart';
import 'package:atti/commons/RoutineBox2.dart';
import 'package:atti/commons/RoutineModal.dart';
import 'package:atti/commons/ScheduleBox.dart';
import 'package:atti/commons/ScheduleModal.dart';
import 'package:atti/commons/SimpleAppBar.dart';

// data ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
import 'package:atti/data/memory/chatController.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:atti/data/memory/memory_note_service.dart';

import 'package:atti/data/notification/notification.dart';
import 'package:atti/data/notification/notification_controller.dart';

import 'package:atti/data/report/dangerword_controller.dart';
import 'package:atti/data/report/emotion_controller.dart';
import 'package:atti/data/report/reportController.dart';
import 'package:atti/data/report/viewsController.dart';

import 'package:atti/data/routine/routine_controller.dart';
import 'package:atti/data/routine/routine_model.dart';
import 'package:atti/data/routine/routine_service.dart';

import 'package:atti/data/schedule/schedule_model.dart';
import 'package:atti/data/schedule/schedule_service.dart';
import 'package:atti/data/schedule/schedule_controller.dart';

import 'package:atti/data/signup_login/LoginController.dart';
import 'package:atti/data/signup_login/SignUpController.dart';
import 'package:atti/data/auth_controller.dart';

// screen ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
import 'package:atti/tmp/screen/HomeCarer.dart';
import 'package:atti/tmp/screen/HomePatient.dart';
import 'package:atti/tmp/screen/Menu.dart';
import 'package:atti/tmp/screen/RoutineScheduleMain.dart';

// chatbot
import 'package:atti/tmp/screen/chatbot/Chatbot.dart';
import 'package:atti/tmp/screen/chatbot/RecollectionChatbot.dart';

// LoginSignUp
import 'package:atti/tmp/screen/LoginSignUp/CustomerTypeBtn.dart';
import 'package:atti/tmp/screen/LoginSignUp/EntryField.dart';
import 'package:atti/tmp/screen/LoginSignUp/FinishSignUpScreen.dart';
import 'package:atti/tmp/screen/LoginSignUp/IntroPage.dart';
import 'package:atti/tmp/screen/LoginSignUp/LoginEntryField.dart';
import 'package:atti/tmp/screen/LoginSignUp/LogInScreen.dart';
import 'package:atti/tmp/screen/LoginSignUp/LogInSignUpMainScreen.dart';
import 'package:atti/tmp/screen/LoginSignUp/NextBtn.dart';
import 'package:atti/tmp/screen/LoginSignUp/SignUpFamilyTag.dart';
import 'package:atti/tmp/screen/LoginSignUp/SignUpScreen1.dart';
import 'package:atti/tmp/screen/LoginSignUp/SignUpScreen2.dart';
import 'package:atti/tmp/screen/LoginSignUp/SignUpScreen3.dart';

// memory
import 'package:atti/tmp/screen/memory/chat/BeforeSave.dart';
import 'package:atti/tmp/screen/memory/chat/Chat.dart';
import 'package:atti/tmp/screen/memory/chat/ChatBubble.dart';
import 'package:atti/tmp/screen/memory/chat/ChatComplete.dart';
import 'package:atti/tmp/screen/memory/chat/ChatHistory.dart';
import 'package:atti/tmp/screen/memory/chat/RecollectionChat.dart';

import 'package:atti/tmp/screen/memory/gallery/GalleryOption.dart';
import 'package:atti/tmp/screen/memory/gallery/MainGallery.dart';
import 'package:atti/tmp/screen/memory/gallery/MemoryDetail.dart';
import 'package:atti/tmp/screen/memory/gallery/RecollectionData.dart';
import 'package:atti/tmp/screen/memory/gallery/RecollectionDetail.dart';
import 'package:atti/tmp/screen/memory/gallery/TagController.dart';

import 'package:atti/tmp/screen/memory/register/MemoryRegister1.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister2.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister3.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister4.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegisterCheck.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegisterFinish.dart';

// Notice
import 'package:atti/tmp/screen/Notice/FullScreenRoutine.dart';
import 'package:atti/tmp/screen/Notice/FullScreenSchedule1.dart';
import 'package:atti/tmp/screen/Notice/FullScreenSchedule2.dart';
import 'package:atti/tmp/screen/Notice/FullScreenSchedule3.dart';
import 'package:atti/tmp/screen/Notice/NoticeMain.dart';

// report
import 'package:atti/tmp/screen/report/ReportDetail.dart';
import 'package:atti/tmp/screen/report/ReportHistory.dart';

// routine
import 'package:atti/tmp/screen/routine/register/RoutineRegister1.dart';
import 'package:atti/tmp/screen/routine/register/RoutineRegister2.dart';
import 'package:atti/tmp/screen/routine/register/RoutineRegister3.dart';
import 'package:atti/tmp/screen/routine/register/RoutineRegisterCheck.dart';
import 'package:atti/tmp/screen/routine/register/RoutineRegisterFinish.dart';
import 'package:atti/tmp/screen/routine/RoutineFinish.dart';

// schedule
import 'package:atti/tmp/screen/schedule/finish/ScheduleFinish1.dart';
import 'package:atti/tmp/screen/schedule/finish/ScheduleFinish2.dart';

import 'package:atti/tmp/screen/schedule/register/ScheduleRegister1.dart';
import 'package:atti/tmp/screen/schedule/register/ScheduleRegister2.dart';
import 'package:atti/tmp/screen/schedule/register/ScheduleRegister3.dart';
import 'package:atti/tmp/screen/schedule/register/ScheduleRegister4.dart';
import 'package:atti/tmp/screen/schedule/register/ScheduleRegisterCheck.dart';
import 'package:atti/tmp/screen/schedule/register/ScheduleRegisterFinish.dart';
