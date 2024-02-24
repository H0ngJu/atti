<!--![Frame 8](https://github.com/H0ngJu/atti/assets/106425326/bf80130e-cc07-4d29-aed6-41065fd09180)-->
<!--![Frame 10](https://github.com/H0ngJu/atti/assets/106425326/f199cb2e-57e0-4a84-b824-f33313eb2e35)-->
![Frame 8](https://github.com/H0ngJu/atti/assets/106425326/574cbb35-5e7f-4e26-b7d0-ef19bc3cdd39)

# ATTI
---
The project proposes a solution to help people with mild dementia with memory decline, which is characterized by "forgetting important memories from the past" and "forgetting to remember things in everyday life". Through Ati, a chatbot that can be found in the app, dementia patients can **recall meaningful memories from the past and build a regular life in the present and future**.
    

Youtube : [[ATTI] - GDSC Solution Challenge 2024](https://www.youtube.com/watch?v=eCIppc-osqE)



# How To Run
---

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

# Contents

1. [Overview](#Overview)
2. [Necessity](#Necessity)
4. [UN SDGs](#UN_SDGs)
5. [Skill](#Skill)
6. [Screens](#Screens)
7. [Expected Effect]
8. [Closing](#Closing)
   
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

---

# UN SDGs 3

![Untitled](https://cdn.imweb.me/upload/S202108243f92708905182/af6401c8a0536.jpg)

---

# Skill

|   Firebase   |    Flutter    |  Gpt3.5 turbo API  |
|:------------:|:-------------:|:-------------:|
|  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Firebase_Logo.svg/1280px-Firebase_Logo.svg.png" alt="Firebase Logo" width="200"> | <img src="https://modulabs.co.kr/wp-content/uploads/2023/06/flutter-logo-sharing.png" alt="Flutter Logo" width="200"> | <img src="https://appmaster.io/api/_files/URQWqPJkzqvi98To3QGKnG/download/" alt="GPT3.5 turbo API" width="200"> |

---

# Screens

### Home

| 1 | 2 | 3 | 4 |
|---------|---------|---------|---------|
| ![image](https://github.com/H0ngJu/atti/assets/106425326/468c3264-637b-4034-97e1-61bf3e03acab) | ![image](https://github.com/H0ngJu/atti/assets/106425326/1e5a83f8-9b55-4a83-8c57-20310823dc40) | ![image](https://github.com/H0ngJu/atti/assets/106425326/de71baff-87f1-48ed-8b99-bb5a9be1c2bc) | ![image](https://github.com/H0ngJu/atti/assets/106425326/0e2fc91c-ff90-47d7-bcbf-2622790082ab) |

### Memory Note

| 1 | 2 | 3 | 4 | 5 | 6 |
|---------|---------|---------|---------|---------|---------|
| ![image](https://github.com/H0ngJu/atti/assets/106425326/52c4b089-03a7-4782-9b6d-19e38e447ef8) | ![image](https://github.com/H0ngJu/atti/assets/106425326/cfee8a67-56e3-494a-911f-cfe3aded0127) | ![image](https://github.com/H0ngJu/atti/assets/106425326/f7a87ba5-1992-4c5d-959a-b1ffbcd251ec) | ![image](https://github.com/H0ngJu/atti/assets/106425326/7e1f8997-3a14-4d4f-94c8-521a6c570933) | ![image](https://github.com/H0ngJu/atti/assets/106425326/afbe55bd-a1be-44db-beb3-cc1a9f24b3f3) | ![image](https://github.com/H0ngJu/atti/assets/106425326/cab17a41-8ae3-4f9e-b2f3-db4e48c60bea) |



### Routine

| 1 | 2 |
|---------|---------|
| <img src="https://github.com/H0ngJu/atti/assets/106425326/cae55e78-065f-4fd4-b69f-b697e71de8fd" width="200"> | <img src="https://github.com/H0ngJu/atti/assets/106425326/c0e7e97d-66fc-40ad-a94f-7b1d9098c9e4" width="200"> |


### Schedule

| 1 | 2 |
|---------|---------|
| <img src="https://github.com/H0ngJu/atti/assets/106425326/10bee284-c706-4c71-bc9d-3c91c95d0bc8" width="200"> | <img src="https://github.com/H0ngJu/atti/assets/106425326/5e8bc055-d244-40c9-bf29-85b09487e88a" width="200"> |


### Report

| 1 | 2 | 3 |
|---------|---------|----------|
| <img src="https://github.com/H0ngJu/atti/assets/106425326/e0c2444a-03dc-4ec9-8def-56bc164fad8c" width="200"> | <img src="https://github.com/H0ngJu/atti/assets/106425326/71a664dd-60cf-4dbb-9e79-60b87c341e95" width="200"> | <img src="https://github.com/H0ngJu/atti/assets/106425326/58cfc924-5135-4f7a-8574-02d09ce6265b" width="200"> |

### Alert

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/1b31276c-d22e-4d55-b95d-ee063d938df3/89f6249b-0bce-4203-b994-eb9ff18992ca/Untitled.png)


---

# Closing

'The memories of the past are viewed.'

'Today's memories are recorded for the future.'

This app brings together the past, present, and future of people with dementia.

"Many people think that if you have dementia you have to live in a hopeless state, with no hope and no pleasure, but that's not the case." -Alzheimer's Society, UK

While dementia has been identified as one of the negative aspects of living longer, it is possible to live well as the disease progresses with the right support from those around you.

The 'ATTI' app connects people with dementia to their past, present, and future through positive memory recall, improving their psychological well-being and quality of life. 

We want to realize a future where dementia, which can strike anyone at any time, is not something to be feared, but something to be prepared for.

