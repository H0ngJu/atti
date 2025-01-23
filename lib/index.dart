// 공통
export 'package:flutter/material.dart';
export 'package:get/get.dart';
export 'dart:math';
export 'package:flutter/services.dart';

// 파이어베이스
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_storage/firebase_storage.dart';
export 'package:firebase_auth/firebase_auth.dart';

// commons ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
export 'package:atti/commons/AttiAppBar.dart';
export 'package:atti/commons/AttiBottomNavi.dart';
export 'package:atti/commons/AttiSpeechBubble.dart';
export 'package:atti/commons/BottomNextButton.dart';
export 'package:atti/commons/colorPallet.dart';
export 'package:atti/commons/DetailPageTitle.dart';
export 'package:atti/commons/ErrorMessageWidget.dart';
export 'package:atti/commons/FinishScreen.dart';
export 'package:atti/commons/RoutineBox.dart';
export 'package:atti/commons/RoutineBox2.dart';
export 'package:atti/commons/RoutineModal.dart';
export 'package:atti/commons/ScheduleBox.dart';
export 'package:atti/commons/ScheduleModal.dart';
export 'package:atti/commons/SimpleAppBar.dart';

// data ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
export 'package:atti/data/memory/chatController.dart';
export 'package:atti/data/memory/memory_note_controller.dart';
export 'package:atti/data/memory/memory_note_model.dart';
export 'package:atti/data/memory/memory_note_service.dart';

export 'package:atti/data/notification/notification.dart';
export 'package:atti/data/notification/notification_controller.dart';

export 'package:atti/data/report/dangerword_controller.dart';
export 'package:atti/data/report/emotion_controller.dart';
export 'package:atti/data/report/reportController.dart';
export 'package:atti/data/report/viewsController.dart';

export 'package:atti/data/routine/routine_controller.dart';
export 'package:atti/data/routine/routine_model.dart';
export 'package:atti/data/routine/routine_service.dart';

export 'package:atti/data/schedule/schedule_model.dart';
export 'package:atti/data/schedule/schedule_service.dart';
export 'package:atti/data/schedule/schedule_controller.dart';

export 'package:atti/data/signup_login/LoginController.dart';
export 'package:atti/data/signup_login/SignUpController.dart';
export 'package:atti/data/auth_controller.dart';

// screen ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
export 'package:atti/tmp/screen/HomeCarer.dart';
// export 'package:atti/tmp/screen/HomePatient.dart';
export 'package:atti/tmp/screen/Menu.dart';
// 'package:atti/tmp/screen/CarerRoutineScheduleMain.dart';

// chatbot
export 'package:atti/tmp/screen/chatbot/Chatbot.dart';
export 'package:atti/tmp/screen/chatbot/RecollectionChatbot.dart';

// LoginSignUp
export 'package:atti/tmp/screen/LoginSignUp/EntryField.dart';
export 'package:atti/tmp/screen/LoginSignUp/FinishSignUpScreen.dart';
export 'package:atti/tmp/screen/LoginSignUp/IntroPage.dart';
export 'package:atti/tmp/screen/LoginSignUp/LoginEntryField.dart';
export 'package:atti/tmp/screen/LoginSignUp/LogInScreen.dart';
export 'package:atti/tmp/screen/LoginSignUp/LogInSignUpMainScreen.dart';
export 'package:atti/tmp/screen/LoginSignUp/NextBtn.dart';
export 'package:atti/tmp/screen/LoginSignUp/SignUpFamilyTag.dart';

// memory
export 'package:atti/tmp/screen/memory/chat/BeforeSave.dart';
export 'package:atti/tmp/screen/memory/chat/Chat.dart';
export 'package:atti/tmp/screen/memory/chat/ChatBubble.dart';
export 'package:atti/tmp/screen/memory/chat/ChatComplete.dart';
// export 'package:atti/tmp/screen/memory/chat/ChatHistory.dart';
// export 'package:atti/tmp/screen/memory/chat/RecollectionChat.dart';

export 'package:atti/tmp/screen/memory/gallery/GalleryOption.dart';
export 'package:atti/tmp/screen/memory/gallery/MainGallery.dart';
export 'package:atti/tmp/screen/memory/gallery/MemoryDetail.dart';
export 'package:atti/tmp/screen/memory/gallery/RecollectionDetail.dart';
export 'package:atti/tmp/screen/memory/gallery/TagController.dart';

export 'package:atti/tmp/screen/memory/register/MemoryRegister1.dart';
export 'package:atti/tmp/screen/memory/register/MemoryRegister2.dart';
export 'package:atti/tmp/screen/memory/register/MemoryRegister3.dart';
export 'package:atti/tmp/screen/memory/register/MemoryRegister4.dart';
export 'package:atti/tmp/screen/memory/register/MemoryRegisterCheck.dart';
export 'package:atti/tmp/screen/memory/register/MemoryRegisterFinish.dart';

// Notice
// export 'package:atti/tmp/screen/Notice/FullScreenRoutine.dart';
// export 'package:atti/tmp/screen/Notice/FullScreenSchedule1.dart';
// export 'package:atti/tmp/screen/Notice/FullScreenSchedule2.dart';
// export 'package:atti/tmp/screen/Notice/FullScreenSchedule3.dart';
export 'package:atti/tmp/screen/Notice/NoticeMain.dart';

// report
export 'package:atti/tmp/screen/report/ReportDetail.dart';
export 'package:atti/tmp/screen/report/ReportHistory.dart';

// routine
export 'package:atti/patient/screen/routine_schedule/routine_register/RoutineRegister1.dart';
export 'package:atti/patient/screen/routine_schedule/routine_register/RoutineRegister2.dart';
export 'package:atti/patient/screen/routine_schedule/routine_register/RoutineRegister3.dart';
export 'package:atti/patient/screen/routine_schedule/routine_register/RoutineRegisterCheck.dart';
export 'package:atti/patient/screen/routine_schedule/routine_register/RoutineRegisterFinish.dart';
export 'package:atti/patient/screen/routine_schedule/RoutineShceduleFinish.dart';
export 'package:atti/patient/screen/routine_schedule/RoutineScheduleMain.dart';
export 'package:atti/patient/screen/routine_schedule/TodayToDo.dart';


// schedule
export 'package:atti/tmp/screen/schedule/finish/ScheduleFinish1.dart';
export 'package:atti/tmp/screen/schedule/finish/ScheduleFinish2.dart';

export 'package:atti/patient/screen/routine_schedule/schedule_register/ScheduleRegister1.dart';
export 'package:atti/patient/screen/routine_schedule/schedule_register/ScheduleRegister2.dart';
export 'package:atti/patient/screen/routine_schedule/schedule_register/ScheduleRegister3.dart';
export 'package:atti/patient/screen/routine_schedule/schedule_register/ScheduleRegister4.dart';
export 'package:atti/patient/screen/routine_schedule/schedule_register/ScheduleRegisterCheck.dart';
export 'package:atti/patient/screen/routine_schedule/schedule_register/ScheduleRegisterFinish.dart';

