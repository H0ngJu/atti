// The Cloud Functions for Firebase SDK to set up triggers and logging.
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const functions = require('firebase-functions');
const admin = require("firebase-admin");
admin.initializeApp();

// ====================================================================================
// 2024.04.28~ 수정사항
// 1. 리포트 일정 완료율 가공
// 2. 리포트 일과 완료율 가공
// 3. 위험단어 분석
// ====================================================================================

 // getdatatest 성공! get set 성공 ^_^
// exports.getdatatest = onSchedule("* * * * *", async (event) => {
//   const userSnapshot = await admin
//     .firestore()
//     .collection("user")
//     .where("isPatient", "==", true)
//     .get();
//   userSnapshot.forEach(async (userDoc) => {
//     await admin.firestore().collection("test").add(userDoc.data());
//   });
// });

exports.weeklyReport = onSchedule(
  {
    // schedule: "* * * * *", // 00시 00분 실행되는 코드
    schedule: "0 0 * * 0", // 매주 일요일에서 월요일로 넘어가는 자정에 실행되도록
    region: "asia-northeast3",
    timeZone: "Asia/Seoul",
  },
  async (event) => {
    // 지난 월요일과 일요일의 날짜를 가져온다.
    const now = new Date();
    const monday = new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate() - (now.getDay() == 0 ? 6 : now.getDay() - 1)
    );
    monday.setHours(0, 0, 0, 0);
    const sunday = new Date(monday);
    sunday.setDate(monday.getDate() + 6);
    sunday.setHours(23, 59, 59, 999);
    const userSnapshot = await admin
      .firestore()
      .collection("user")
      .where("isPatient", "==", true)
      .get();
    let reportPeriod = [
      monday.toISOString().split("T")[0],
      sunday.toISOString().split("T")[0],
    ];
    for (const userDoc of userSnapshot.docs) {
      // 월요일부터 일요일까지의 조회수 데이터를 가져온다
      // let dataForTestCollection = []; // 각 사용자에 대해 초기화
      const userId = userDoc.ref;
      const viewsSnapshot = await admin
        .firestore()
        .collection("views")
        .where("patientId", "==", userId) // 참조
        .where("createdAt", ">=", admin.firestore.Timestamp.fromDate(monday))
        .where("createdAt", "<=", admin.firestore.Timestamp.fromDate(sunday))
        .get();
      // 월요일주터 일요일까지의 기억노트 등록 데이터를 가져온다.
      const registeredMemorySnapshot = await admin
        .firestore()
        .collection("memoryNote")
        .where("patientId", "==", userId) // 참조
        .where("createdAt", ">=", admin.firestore.Timestamp.fromDate(monday))
        .where("createdAt", "<=", admin.firestore.Timestamp.fromDate(sunday))
        .get();
      // 루틴 데이터를 가져온다.
      const routineSnapshot = await admin
        .firestore()
        .collection("routine")
        .where("patientId", "==", userId) // 참조
        .get();
      // 주간 감정 데이터를 가져온다.
      const emotionsSnapshot = await admin
        .firestore()
        .collection("weekly_emotion")
        .where("patientDocRef", "==", userId) // 참조
        .where("createdAt", ">=", admin.firestore.Timestamp.fromDate(monday))
        .where("createdAt", "<=", admin.firestore.Timestamp.fromDate(sunday))
        .get();
      // 스케쥴 데이터를 가져온다.
      const scheduleSnapshot = await admin
        .firestore()
        .collection("schedule")
        .where("patientId", "==", userId) // 참조
        .where("createdAt", ">=", admin.firestore.Timestamp.fromDate(monday))
        .where("createdAt", "<=", admin.firestore.Timestamp.fromDate(sunday))
        .get();
      // 위험단어 데이터를 가져온다.
      const dangerWordSnapshot = await admin
        .firestore()
        .collection("dangerWord")
        .where("patientDocRef", "==", userId) // 참조
        .where("createdAt", ">=", admin.firestore.Timestamp.fromDate(monday))
        .where("createdAt", "<=", admin.firestore.Timestamp.fromDate(sunday))
        .get();
      let reportData = {};
      reportData.reportPeriod = reportPeriod;

      // mostViews ====================================================================
      let viewCounts = {}; // 각 메모리의 조회수를 저장
      if (viewsSnapshot && viewsSnapshot.forEach) {
        viewsSnapshot.forEach((doc) => {
          const data = doc.data();
          const memoryViews = data.memoryViews;
          for (let memoryRef in memoryViews) {
            if (memoryViews.hasOwnProperty(memoryRef)) {
              if (!viewCounts[memoryRef]) {
                viewCounts[memoryRef] = 0;
              }
              viewCounts[memoryRef] += memoryViews[memoryRef];
            }
          }
        });
      }
      // 조회수를 기준으로 메모리를 정렬하고 상위 3개를 가져옴
      let mostViewedMemories = Object.entries(viewCounts)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 3);

      // 가장 많이 조회된 메모리를 보고서 데이터에 추가
      let tmp = 0,
        tmpRef = "";
      reportData.mostViews = {};
      if (mostViewedMemories && mostViewedMemories.forEach) {
        mostViewedMemories.forEach(([memoryRef, views]) => {
          if (tmp < views) {
            tmp = views;
            tmpRef = memoryRef;
          }
          reportData.mostViews[memoryRef] = views;
        });
      }
      let tmpDocSnapshot;
      let highestViewedMemory = "";
      if (tmpRef.length > 0) {
        tmpDocSnapshot = await admin.firestore().doc(tmpRef).get();
        if (tmpDocSnapshot.exists) {
          highestViewedMemory = tmpDocSnapshot.data()["imgTitle"];
        }
      }
      reportData.highestViewedMemory = highestViewedMemory;

      // registered Memory Count ====================================================================
      // registered Memory 일별 카운팅
      let weekMap = new Map();
      for (let d = new Date(monday); d <= sunday; d.setDate(d.getDate() + 1)) {
        let dateKey = d.toISOString().split("T")[0]; // Date를 'YYYY-MM-DD' 형태로 변환
        weekMap.set(dateKey, 0);
      }
      if (registeredMemorySnapshot && registeredMemorySnapshot.forEach) {
        registeredMemorySnapshot.forEach((snapshot) => {
          const createdAt = snapshot.data().createdAt.toDate();
          let dateKey = createdAt.toISOString().split("T")[0];

          if (weekMap.has(dateKey)) {
            weekMap.set(dateKey, weekMap.get(dateKey) + 1);
          }
        });
      }
      // map 형태의 일별 등록 기억 수를 일반 js 객체로 변경하여 저장
      reportData.registerdMemoryCount = Object.fromEntries(weekMap);

      // unfinishedRoutine ==========================================================================
      // 월요일과 일요일 사이의 모든 날짜를 생성하는 함수
      function getDatesBetween(startDate, endDate) {
        let dates = [];
        // 시작 날짜로부터 루프 시작
        let currentDate = new Date(startDate);
        // endDate를 포함하도록 <= 조건 사용
        while (currentDate <= endDate) {
          // 날짜를 YYYY-MM-DD 형식의 문자열로 변환하여 배열에 추가
          dates.push(currentDate.toISOString().split("T")[0]);
          // currentDate를 다음 날짜로 업데이트
          currentDate = new Date(
            currentDate.setDate(currentDate.getDate() + 1)
          );
        }
        return dates;
      }
      let allDatesBetween = getDatesBetween(monday, sunday);

      let routineCompletion = {};

      allDatesBetween.forEach((date) => {
        if (!routineCompletion[date]) {
          routineCompletion[date] = { total: 0, completed: 0 };
        }
      });

      let unfinishedRoutines = [];
      if (routineSnapshot && routineSnapshot.forEach) {
        routineSnapshot.forEach((doc) => {
          const data = doc.data();
          const isFinished = data.isFinished;

          // isFinished 맵 내에서 조건에 맞는 데이터를 찾는다
          Object.keys(isFinished).forEach((date) => {
            const dateObj = new Date(date);
            const isFinishedStatus = isFinished[date];
            const dateString = dateObj.toISOString().split("T")[0];
            // 지정한 기간 내의 날짜인지 확인
            if (dateObj >= monday && dateObj <= sunday) {
              // routineCompletionRate에 해당 날짜가 이미 있으면 값을 업데이트, 없으면 초기화
              if (!routineCompletion[dateString]) {
                routineCompletion[dateString] = { total: 0, completed: 0 };
              }

              // total 스케줄 수 증가
              routineCompletion[dateString].total += 1;

              // 완료된 경우, completed 스케줄 수 증가
              if (isFinishedStatus) {
                routineCompletion[dateString].completed += 1;
              }
              // 지난 주 월요일 이후이며 일요일 이전의 날짜이고, 완료되지 않은 경우
              if (!isFinishedStatus) {
                // 조건에 맞는 경우, 새 배열에 문서 ID와 날짜를 저장
                unfinishedRoutines.push({
                  routineRef: doc.ref, // 문서 ID
                  date: date, // 완료되지 않은 날짜
                });
              }
            }
          });
        });
      }
      // 레포트에 저장
      reportData.unfinishedRoutine = unfinishedRoutines;
      reportData.routineCompletion = routineCompletion;

      // weekly emotion ==========================================================================
      let weeklyEmotion = {};
      if (emotionsSnapshot && emotionsSnapshot.forEach) {
        emotionsSnapshot.forEach((doc) => {
          const data = doc.data();
          const emotionsList = data.emotionsList;
          // emotionsList가 배열인지 확인
          if (Array.isArray(emotionsList)) {
            emotionsList.forEach((emotion) => {
              if (weeklyEmotion[emotion]) {
                // 이미 weeklyEmotion에 해당 감정 단어가 있으면 횟수를 1 증가
                weeklyEmotion[emotion] += 1;
              } else {
                // 해당 감정 단어가 weeklyEmotion에 없으면 새로 추가하고 횟수를 1로 설정
                weeklyEmotion[emotion] = 1;
              }
            });
          }
        });
      }
      reportData.weeklyEmotion = weeklyEmotion;

      // unfinishedSchedule =======================================================================
      let scheduleCompletion = {};

      allDatesBetween.forEach((date) => {
        if (!scheduleCompletion[date]) {
          scheduleCompletion[date] = { total: 0, completed: 0 };
        }
      });

      let unfinishedSchedule = [];
      if (scheduleSnapshot && scheduleSnapshot.forEach) {
        scheduleSnapshot.forEach((doc) => {
          const data = doc.data();
          const isFinished = data.isFinished;

          // 날짜를 yyyy-mm-dd 형식의 문자열로 변환
          const date = data.createdAt.toDate().toISOString().split("T")[0];
          // 해당 날짜에 대한 데이터가 없으면 초기화
          if (!scheduleCompletion[date]) {
            scheduleCompletion[date] = { total: 0, completed: 0 };
          }
          // 스케줄 수를 카운트합니다.
          scheduleCompletion[date].total += 1;
          // 완료된 스케줄을 카운트합니다.
          if (isFinished) {
            scheduleCompletion[date].completed += 1;
          }
          // 미완료 스케줄 참조 리스트 삽입
          if (!isFinished) {
            unfinishedSchedule.push(doc.ref);
          }
        });
      }

      reportData.unfinishedSchedule = unfinishedSchedule;
      reportData.scheduleCompletion = scheduleCompletion;

      // danger Words ==========================================================================
      let dangerWords = {};
      if (dangerWordSnapshot && dangerWordSnapshot.forEach) {
        dangerWordSnapshot.forEach((doc) => {
          const data = doc.data();
          const dangerWordsList = data.dangerWordsList;
          // emotionsList가 배열인지 확인
          if (Array.isArray(dangerWordsList)) {
            dangerWordsList.forEach((word) => {
              if (dangerWords[word]) {
                // 이미 dangerWords에 해당 감정 단어가 있으면 횟수를 1 증가
                dangerWords[word] += 1;
              } else {
                // 해당 감정 단어가 dangerWords에 없으면 새로 추가하고 횟수를 1로 설정
                dangerWords[word] = 1;
              }
            });
          }
        });
      }
      reportData.dangerWords = dangerWords;

      // 현재 타임스탬프를 보고서 데이터에 추가
      reportData.createdAt = admin.firestore.Timestamp.now();
      reportData.patientId = userId;
      // 처리된 데이터를 'report' 컬렉션에 추가
      await admin.firestore().collection("report").add(reportData);
    }
  }
);

// ======================================================================
// 환자가 일정/일과 완료 시 보호자 계정으로 알림을 보내는 함수
//exports.sendNotificationOnFinish = functions.firestore
//    .document('notification_finish/{documentId}')
//    .onCreate((snap, context) => {
//        const documentData = snap.data();
//        const title = documentData.title; // 알림 제목
//        const message = documentData.message; // 알림 본문
//        const patientDocRefPath = documentData.patientDocRef.path;
//
//        // patientDocRef를 이용하여 환자 문서에서 보호자의 레퍼런스를 가져옴
//        return admin.firestore().doc(patientDocRefPath).get().then(patientDoc => {
//            const carerRef = patientDoc.data().carerRef.path;
//
//            // 보호자 레퍼런스를 이용하여 보호자 문서에서 FCM 토큰을 가져옴
//            return admin.firestore().doc(carerRef).get().then(carerDoc => {
//                const userFCMToken = carerDoc.data().userFCMToken;
//
//                // FCM 메시지 구성
//                const notificationMessage = {
//                    notification: {
//                        title: title, // 알림 제목
//                        body: message, // 알림 본문
//                    },
//                    token: userFCMToken, // 보호자의 FCM 토큰
//                };
//
//                // FCM을 이용하여 알림 메시지 전송
//                return admin.messaging().send(notificationMessage);
//            });
//        }).catch(error => {
//            console.log('Error sending notification:', error);
//            return null;
//        });
//    });

exports.sendNotificationOnFinish = onDocumentCreated(
  "notification_finish/{documentId}",
  async (event) => {
    try {
      const documentData = event.data;
      const title = documentData.title;
      const message = documentData.message;
      const patientDocRefPath = documentData.patientDocRef.path;

      const patientDoc = await admin.firestore().doc(patientDocRefPath).get();
      if (!patientDoc.exists) {
        throw new Error("Patient document does not exist.");
      }
      const carerRefPath = patientDoc.data().carerRef.path;

      const carerDoc = await admin.firestore().doc(carerRefPath).get();
      if (!carerDoc.exists) {
        throw new Error("Carer document does not exist.");
      }
      const userFCMToken = carerDoc.data().userFCMToken;
      if (!userFCMToken) {
        throw new Error("FCM token is missing.");
      }

      const notificationMessage = {
        notification: {
          title: title,
          body: message,
        },
        token: userFCMToken,
      };

      await admin.messaging().send(notificationMessage);
      console.log("Notification sent successfully.");
    } catch (error) {
      console.error("Error in sendNotificationOnFinish:", error);
    }
  }
);



// ======================================================================
// 요일 문자열을 숫자로 변환
const dayToNumber = {
  일: 0, // Sunday
  월: 1, // Monday
  화: 2,
  수: 3,
  목: 4,
  금: 5,
  토: 6, // Saturday
};

// Firestore 객체 생성
const _firestore = admin.firestore();

exports.createRoutineScheduler = onDocumentCreated(
  "routine/{documentId}",
  async (event) => {
    const data = event.data;
    if (!data || data.isPatient) return;

    const { name, time, repeatDays, patientId } = data;
    const patientDoc = await _firestore.doc(patientId).get();

    if (!patientDoc.exists) {
      console.error("Patient document not found:", patientId);
      return;
    }

    const patientFCMToken = patientDoc.data().userFCMToken;
    if (!patientFCMToken) {
      console.error("FCM Token not found for patient:", patientId);
      return;
    }

    // 반복 요일마다 Scheduler 생성
    for (const day of repeatDays) {
      const cronDay = dayToCron[day];
      if (!cronDay) {
        console.error("Invalid repeat day:", day);
        continue;
      }

      const schedulerName = `routine-${event.params.documentId}-${day}`;

      // Scheduler 생성
      await onSchedule({
        name: schedulerName,
        schedule: `30 ${time[1]} ${time[0]} * * ${cronDay}`, // 매주 특정 요일에 실행
        timeZone: "Asia/Seoul",
      })
        .onRun(async () => {
          const notificationMessage = {
            notification: {
              title: "일과 알림",
              body: `'${name}' 일과를 완료하셨나요?`,
            },
            token: patientFCMToken,
          };

          try {
            await admin.messaging().send(notificationMessage);
            console.log(`Routine notification sent for '${name}' to ${patientFCMToken}`);
          } catch (error) {
            console.error("Error sending FCM notification:", error);
          }
        });
    }

    console.log("Routine schedulers created successfully.");
  }
);

// 보호자 계정으로 일과 등록 시 해당 시각에 환자 계정으로 알림을 보내는 함수
//exports.sendRoutineNotiFromCarerToPatient
//    .document('Routine/{documentId}')
//    .onCreate((snapshot, context) => {
//        const documentData = snap.data();
//
//        // 보호자일 때만 실행
//        if (documentData && documentData.isPatient === false) {
//            const name = documentData.name; // 일과 이름
//            const time = documentData.time; // 일과 시간. [14, 30] 형식
//            const repeatDays = documentData.repeatDays; // 반복 요일. ['금', '토', '일'] 형식
//            const patientDocRefPath = documentData.patientId.path; // 보호자와 연결된 환자의 도큐먼트 레퍼런스
//
//            // patientDocRefPath 이용하여 환자 도큐먼트 불러옴
//            return admin.firestore().doc(patientDocRefPath).get().then(
//                patientDoc => {
//                    const userFCMToken = patientDoc.data().userFCMToken; // 환자의 FCM 토큰
//
//                    // FCM 메시지 구성
//                    const notificationMessage = {
//                        notification: {
//                            title: '일과 알림',
//                            message: '\'${name}\' 일과를 완료하셨나요?'
//                        },
//                        token: userFCMToken
//                    }
//
//                }
//            )
//        }
//
//    });