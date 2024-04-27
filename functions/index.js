// The Cloud Functions for Firebase SDK to set up triggers and logging.
const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");
admin.initializeApp();

// // getdatatest 성공! get set 성공 ^_^
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
    schedule: "0 0 * * *", // 00시 00분 실행되는 코드
    // schedule: "0 0 * * 0", // 매주 일요일에서 월요일로 넘어가는 자정에 실행되도록
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
      // 월요일부터 일요일까지의 미완료 루틴 등록 데이터를 가져온다.
      // 수정 필요
      const routineSnapshot = await admin
        .firestore()
        .collection("routine")
        .where("patientId", "==", userId) // 참조
        .get();

      let reportData = {};

      // mostViews ====================================================================
      let viewCounts = {}; // 각 메모리의 조회수를 저장
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
      // 조회수를 기준으로 메모리를 정렬하고 상위 3개를 가져옴
      let mostViewedMemories = Object.entries(viewCounts)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 3);
      // 가장 많이 조회된 메모리를 보고서 데이터에 추가
      reportData.mostViews = {};
      mostViewedMemories.forEach(([memoryRef, views]) => {
        reportData.mostViews[memoryRef] = views;
      });

      // registered Memory Count ====================================================================
      // registered Memory 일별 카운팅
      let weekMap = new Map();
      for (let d = new Date(monday); d <= sunday; d.setDate(d.getDate() + 1)) {
        let dateKey = d.toISOString().split("T")[0]; // Date를 'YYYY-MM-DD' 형태로 변환
        weekMap.set(dateKey, 0);
      }
      registeredMemorySnapshot.forEach((snapshot) => {
        const createdAt = snapshot.data().createdAt.toDate();
        let dateKey = createdAt.toISOString().split("T")[0];

        if (weekMap.has(dateKey)) {
          weekMap.set(dateKey, weekMap.get(dateKey) + 1);
        }
      });
      // map 형태의 일별 등록 기억 수를 일반 js 객체로 변경하여 저장
      reportData.registerdMemoryCount = Object.fromEntries(weekMap);

      // unfinishedRoutine ==========================================================================
      // 완료되지 않은 루틴을 저장할 배열을 초기화
      let unfinishedRoutines = [];
      routineSnapshot.forEach((doc) => {
        const data = doc.data();
        const isFinished = data.isFinished;

        // isFinished 맵 내에서 조건에 맞는 데이터를 찾는다
        Object.keys(isFinished).forEach((date) => {
          const dateObj = new Date(date);
          const isFinishedStatus = isFinished[date];
          // .where("createdAt", ">=", admin.firestore.Timestamp.fromDate(monday))
          // .where("createdAt", "<=", admin.firestore.Timestamp.fromDate(sunday))
          // 지난 주 월요일 이후이며 일요일 이전의 날짜이고, 완료되지 않은 경우
          if (dateObj >= monday && dateObj <= sunday && !isFinishedStatus) {
            // 조건에 맞는 경우, 새 배열에 문서 ID와 날짜를 저장
            unfinishedRoutines.push({
              routineRef: doc.ref, // 문서 ID
              date: date, // 완료되지 않은 날짜
            });
          }
        });
      });
      // 레포트에 저장
      reportData.unfinishedRoutine = unfinishedRoutines;
      // 현재 타임스탬프를 보고서 데이터에 추가
      reportData.createdAt = admin.firestore.Timestamp.now();
      // 처리된 데이터를 'report' 컬렉션에 추가
      await admin.firestore().collection("report").add(reportData);
    }
  }
);
