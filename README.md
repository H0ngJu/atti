<img width="202" alt="Untitled" src="https://github.com/H0ngJu/atti/assets/106425326/19cf611b-308a-457a-b10b-380f2b6e4bdb">


# ATTI

---

경증 치매 환자가 기억력 저하로 겪는 어려움인 ‘과거의 중요한 기억을 잊음’와 ‘일상 생활에서의 기억 소실’에 도움을 주는 솔루션을 제시한 프로젝트다. 치매 환자는 앱에서 만날 수 있는 챗봇 ‘아띠’를 통해 과거의 의미있는 기억을 회상하고 현재와 미래의 규칙적인 생활을 구축할 수 있다.

- 영어
    
    The project proposes a solution to help people with mild dementia with memory decline, which is characterized by "forgetting important memories from the past" and "forgetting to remember things in everyday life". Through Ati, a chatbot that can be found in the app, dementia patients can **recall meaningful memories from the past and build a regular life in the present and future**.
    

[[ATTI] - GDSC Solution Challenge 2024](https://www.youtube.com/watch?v=eCIppc-osqE)

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

<img width="466" alt="Untitled1" src="https://github.com/H0ngJu/atti/assets/106425326/04a7d8a6-9610-4eea-88e1-858a8cb17585">


출처 : BBC NEWS 코리아

South Korea is currently in the midst of a rapid aging process. By 2024, South Korea will be an aging society with more than 14% of the population aged 65 and older, and by 2025, the proportion of seniors will soon exceed 20.8%.

![출처 : KOSIS 국가통계포털 = 통계청]<img width="527" alt="Untitled2" src="https://github.com/H0ngJu/atti/assets/106425326/ae83e671-d286-4d18-b613-faf1417de992">


출처 : KOSIS 국가통계포털 = 통계청

As South Korea's population ages, the incidence of dementia is rising rapidly. As of 2022, the number of dementia patients in Korea is estimated to be around 930,000, according to the Korea Dementia Center.

### Increasing number of people with dementia Worldwide

South Korea is not alone in facing a growing number of dementia patients. According to the World Health Organization (WHO) in 2021, 55 million people are currently living with dementia due to brain-related diseases such as Alzheimer's or stroke. The WHO also projected that the number of people with dementia will continue to rise, reaching about 139 million by 2050.

![출처 : WHO]<img width="927" alt="Untitled3" src="https://github.com/H0ngJu/atti/assets/106425326/9725c132-2a77-466b-917e-b42c2eb11b20">


출처 : WHO

---

# Necessity

## User research

<img width="201" alt="Untitled4" src="https://github.com/H0ngJu/atti/assets/106425326/e27bce6d-5fca-4b26-88b0-8c233fecec37">


<img width="170" alt="Untitled5" src="https://github.com/H0ngJu/atti/assets/106425326/d496a89a-bdf9-423a-ae43-25fce76e867b">








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
