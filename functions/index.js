// Maximum concurrent account deletions.
// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.

const {onSchedule} = require("firebase-functions/v2/scheduler");
const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
// The Firebase Admin SDK to delete inactive users.

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

const admin = require("firebase-admin");
admin.initializeApp();

//const PromisePool = require("es6-promise-pool").default;
//const MAX_CONCURRENT = 3;

exports.weeklyReport = onSchedule({
    schedule: 'every sunday 02:30',
    region: "asia-northeast3",
    timeZone: 'Asia/Seoul'}, (async (event) => {
    // 모든 userId를 가져옵니다
    const userSnapshot = await admin.firestore().collection('user').where('isPatient', '==', true).get();
    const userIds = userSnapshot.docs.map(doc => doc.reference);

    // 각 userId에 대해 처리를 수행합니다
    for (const userId of userIds) {
        // 지난 월요일과 다음 일요일의 날짜를 가져옵니다
        const now = new Date();
        const lastMonday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - (now.getDay() == 0 ? 6 : (now.getDay() - 1)));
        lastMonday.setHours(0, 0, 0, 0);
        const nextSunday = new Date(lastMonday);
        nextSunday.setDate(lastMonday.getDate() + 6);
        nextSunday.setHours(23, 59, 59, 999);

        // 월요일부터 일요일까지의 데이터를 가져옵니다
        const viewsSnapshot = await admin.firestore().collection('views')
            .where('patientId', '==', userId)
            .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(lastMonday))
            .where('createdAt', '<=', admin.firestore.Timestamp.fromDate(nextSunday))
            .get();

        const registeredMemorySnapshot = await admin.firestore().collection('memoryNote')
            .where('patientId', '==', userId)
            .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(lastMonday))
            .where('createdAt', '<=', admin.firestore.Timestamp.fromDate(nextSunday))
            .get();

        //    수정필요! 아직 이모션 어떻게 요약할지 안정함
        //    const emotionKeywordSnapshot = await admin.firestore().collection('emotionKeyword')
        //                .where('createdAt', '>=', lastMonday)
        //                .where('createdAt', '<=', nextSunday)
        //                .get();

        //      수정필요! 로직 ...
        //    const unfinishedRoutineSnapshot = await admin.firestore().collection('routine')
        //                .where('createdAt', '>=', lastMonday)
        //                .where('createdAt', '<=', nextSunday)
        //                .get();

        // 데이터를 처리합니다
        let reportData = {};
        let viewCounts = {};  // 각 메모리의 조회수를 저장합니다
        viewsSnapshot.forEach(doc => {
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

        // 조회수를 기준으로 메모리를 정렬하고 상위 3개를 가져옵니다
        let mostViewedMemories = Object.entries(viewCounts).sort((a, b) => b[1] - a[1]).slice(0, 3);

        // 가장 많이 조회된 메모리를 보고서 데이터에 추가합니다
        reportData.mostViews = {};
        mostViewedMemories.forEach(([memoryRef, views]) => {
            reportData.mostViews[memoryRef] = views;
        });

        // 'memoryNote' 컬렉션의 문서 수를 세어 reportData에 추가합니다
        reportData.registeredMemoryCount = registeredMemorySnapshot.size;

        // 현재 타임스탬프를 보고서 데이터에 추가합니다
        reportData.createdAt = admin.firestore.Timestamp.now();

        // 가정: viewsSnapshot의 모든 문서는 동일한 patientId를 가집니다
        // patientId를 보고서 데이터에 추가합니다
        reportData.patientId = viewsSnapshot.docs[0].data().patientId;

        // 처리된 데이터를 'report' 컬렉션에 추가합니다
        const docRef = await admin.firestore().collection('report').add(reportData);

        // 문서 참조를 보고서 데이터에 추가합니다
        reportData.reference = docRef;

        logger.log("Weekly report generated");
    }
}));
