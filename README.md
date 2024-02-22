![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/2114ca51-dc57-42c1-97ea-a9e0d486e641/Untitled.png)

# ATTI

---

경증 치매 환자가 기억력 저하로 겪는 어려움인 ‘과거의 중요한 기억을 잊음’와 ‘일상 생활에서의 기억 소실’에 도움을 주는 솔루션을 제시한 프로젝트다. 치매 환자는 앱에서 만날 수 있는 챗봇 ‘아띠’를 통해 과거의 의미있는 기억을 회상하고 현재와 미래의 규칙적인 생활을 구축할 수 있다.

- 영어
    
    The project proposes a solution to help people with mild dementia with memory decline, which is characterized by "forgetting important memories from the past" and "forgetting to remember things in everyday life". Through Ati, a chatbot that can be found in the app, dementia patients can **recall meaningful memories from the past and build a regular life in the present and future**.
    

[[ATTI] - GDSC Solution Challenge 2024](https://www.youtube.com/watch?v=eCIppc-osqE)

# 목차

---

---

# How To Run

Here are the steps to download the Flutter app from https://github.com/H0ngJu/atti and run it on Android Studio:

1. Install Flutter and Android Studio.
2. Go to https://github.com/H0ngJu/atti  and download the app.
3. Open Android Studio and select File -> Open from the menu, then open the downloaded app folder.
4. Before Run our application, You need to get an API key for openai and an API key for openwheathermap
    1. Issued your OpenAI API Key
    2. Issued your OpenWheatherMap API Key
5. Create an .env file under your project file and write it like this
    
    ```
    GPT_API_KEY="{Your_API_KEY}"
    OPEN_WEATHER_MAP_API_KEY="{Your_API_KEY}"
    ```
    
6. Once Android Studio loads the project, select Run -> Run from the top menu.
7. Select an emulator or connect a mobile device to run the app.

---

# Overview

### **South Korea's super-aging population**

![출처 : BBC NEWS 코리아](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/d58b98fd-a4db-43ba-9851-8e96c0db408c/Untitled.png)

출처 : BBC NEWS 코리아

South Korea is currently in the midst of a rapid aging process. By 2024, South Korea will be an aging society with more than 14% of the population aged 65 and older, and by 2025, the proportion of seniors will soon exceed 20.8%.

![출처 : KOSIS 국가통계포털 = 통계청](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/74b166ee-de4b-4242-8dd9-0137a6f59bed/Untitled.png)

출처 : KOSIS 국가통계포털 = 통계청

As South Korea's population ages, the incidence of dementia is rising rapidly. As of 2022, the number of dementia patients in Korea is estimated to be around 930,000, according to the Korea Dementia Center.

### Increasing number of people with dementia Worldwide

South Korea is not alone in facing a growing number of dementia patients. According to the World Health Organization (WHO) in 2021, 55 million people are currently living with dementia due to brain-related diseases such as Alzheimer's or stroke. The WHO also projected that the number of people with dementia will continue to rise, reaching about 139 million by 2050.

![출처 : WHO](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/6e39b506-27c9-4288-bdb1-61074c7ff1f6/Untitled.png)

출처 : WHO

---

# Necessity

## User research

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/c8081e97-0a22-4c39-a1db-89fb6c89fc27/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/7accdd1d-ec04-477b-b494-b8ab5826095b/Untitled.png)







# atti

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
