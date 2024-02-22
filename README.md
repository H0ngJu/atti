<img width="202" alt="Untitled" src="https://github.com/H0ngJu/atti/assets/106425326/19cf611b-308a-457a-b10b-380f2b6e4bdb">


# ATTI

---

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

# UN SDGs 3

![Untitled]([https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/eb28e88b-c675-48cd-b264-7f945f0b0f68/Untitled.png](https://cdn.imweb.me/upload/S202108243f92708905182/af6401c8a0536.jpg))

---

# Skill

Firebase

![Untitled]([https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/22b553a5-89b7-4912-8951-90323c8dea96/Untitled.png](https://upload.wikimedia.org/wikipedia/commons/b/bd/Firebase_Logo.png))

Flutter

![Untitled](https://modulabs.co.kr/wp-content/uploads/2023/06/flutter-logo-sharing.png)

Gpt3.5 turbo API

![Untitled](https://appmaster.io/api/_files/URQWqPJkzqvi98To3QGKnG/download/)

---

# Screens

### Home

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/4544272a-995e-4c9f-bebb-bdbe64b7dbf6/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/5975c200-4f9b-4f9a-9771-b998b998ca01/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/7d45618d-dd54-4fff-a4e2-90b22a2a10cb/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/07ce932b-f464-4c84-84e4-1bc04394ff0c/Untitled.png)

### Memory Note

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/b935ff4d-a568-4ee7-aea2-69456eb9de41/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/5aee6ce4-bcaf-4e3a-95af-fe38eb685bac/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/0df90114-6ffc-45e8-8dc3-1a46efb40333/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/23d50fab-2f9a-4769-a6c3-64a8e200ea77/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/c4210a02-05d1-473d-90ff-f1116cce9fbb/Untitled.png)

### Routine

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/92bbbfc3-1247-432b-9a8c-2f3d4cc38738/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/49d91bc7-d5ea-4926-bdeb-93167c956381/Untitled.png)

### Schedule

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/7efb5d7e-ccb6-412d-a8ea-73b4b0804149/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/cf24b4d9-9e5e-4977-816b-06f0f522010a/Untitled.png)

### Report

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/afb70ee0-2eed-41be-af46-0443ed8c9491/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/44e490b0-7eac-4c88-b4e8-ed1bcef3afe0/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/d24d5887-a47b-4479-9d42-4b066e0a8a94/Untitled.png)

### Alert

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/89f6249b-0bce-4203-b994-eb9ff18992ca/Untitled.png)







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
