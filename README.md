<!--![Frame 8](https://github.com/H0ngJu/atti/assets/106425326/bf80130e-cc07-4d29-aed6-41065fd09180)-->
<!--![Frame 10](https://github.com/H0ngJu/atti/assets/106425326/f199cb2e-57e0-4a84-b824-f33313eb2e35)-->
![Frame 8](https://github.com/H0ngJu/atti/assets/106425326/574cbb35-5e7f-4e26-b7d0-ef19bc3cdd39)

# ATTI

The project proposes a solution to help people with mild dementia with memory decline, which is characterized by "forgetting important memories from the past" and "forgetting to remember things in everyday life". Through Atti, a voicebot that can be found in the app, dementia patients can **<u>recall meaningful memories from the past and build a regular life in the present and future</u>**.
    

Youtube : [[ATTI] - GDSC Solution Challenge 2024](https://www.youtube.com/watch?v=eCIppc-osqE)</br>
Youtube : [[ATTI] - GDSC Solution Challenge 2024 | Top 100](https://www.youtube.com/watch?v=0Y95Mzpib4I))

---

# How To Run

Here are the steps to download the Flutter app from https://github.com/H0ngJu/atti and run it on Android Studio:

1. Install Flutter and Android Studio.
2. Go to https://github.com/H0ngJu/atti  and download the app.
3. Open Android Studio and select File -> Open from the menu, then open the downloaded app folder.
4. Before Run our application, You need to get an API key for openai and an API key for openwheathermap
    1. Issued your Gemini API Key
    2. Issued your OpenWheatherMap API Key
5. Create an .env file under your project file and write it like this
    
    ```
    GEMINI_API_KEY="Your_GEMINI_API_KEY"
    OPEN_WEATHER_MAP_API_KEY="Your_OpenWheatherMap_API_KEY"
    ```
    
6. Once Android Studio loads the project, select Run -> Run from the top menu.
7. Select an emulator or connect a mobile device to run the app.

---

# Contents

1. [Overview](#Overview)
2. [Necessity](#Necessity)
3. [What's Different from Before](#What's-Different-from-Before)
4. [UN SDGs](#UN_SDGs)
5. [Skill](#Skill)
6. [Screens](#Screens)
7. [Expected Effect](#Expected_Effect)
8. [Closing](#Closing)
   
---

# Overview

## **South Korea's super-aging population**

<img width="466" alt="Untitled1" src="https://github.com/H0ngJu/atti/assets/106425326/04a7d8a6-9610-4eea-88e1-858a8cb17585">

source : BBC NEWS Korea

South Korea is currently in the midst of a rapid aging process. By 2024, South Korea will be an aging society with more than 14% of the population aged 65 and older, and by 2025, the proportion of seniors will soon exceed 20.8%.

<div style="text-align:center;"><img width="527" alt="Untitled2" src="https://github.com/H0ngJu/atti/assets/106425326/ae83e671-d286-4d18-b613-faf1417de992"></div>

source : KOSIS 국가통계포털

As South Korea's population ages, the incidence of dementia is rising rapidly. As of 2022, the number of dementia patients in Korea is estimated to be around 930,000, according to the Korea Dementia Center.

## Increasing number of people with dementia Worldwide

South Korea is not alone in facing a growing number of dementia patients. According to the World Health Organization (WHO) in 2021, 55 million people are currently living with dementia due to brain-related diseases such as Alzheimer's or stroke. The WHO also projected that the number of people with dementia will continue to rise, reaching about 139 million by 2050.

<img width="927" alt="Untitled3" src="https://github.com/H0ngJu/atti/assets/106425326/9725c132-2a77-466b-917e-b42c2eb11b20">

source : WHO

---

# Necessity

## User research
We spent about two weeks volunteering and conducting user research to understand the challenges of people with dementia, interviewing at the local dementia center twice during this period.
<div style="display: flex; justify-content: center;">
    <img height="300" alt="Untitled4" src="https://github.com/H0ngJu/atti/assets/106425326/e27bce6d-5fca-4b26-88b0-8c233fecec37">
    <img height="300" alt="image" src="https://github.com/H0ngJu/atti/assets/106425326/56e9c722-3c85-4a94-ab69-3da96b2fd15f">
</div>

- First Interview
    
    After the desk research, during the process of proposing a solution, the question kept coming up again and again: would seniors with mild dementia be able to actively use ATTI? Therefore, the first interview focused on understanding their communication skills, smartphone utilization, and functional needs of seniors with dementia.
    
    1. Communication of seniors with mild dementia
        
        We found that the communication skills of the elderly with mild dementia were good: they were able to understand normal speech at a normal pace, even when the voice was not loud enough.
        
    2. Only one of the interviewees did not own a smartphone, confirming the value of ATTI as an application solution. In addition, Korean 60-somethings will be more proficient with smartphones in the future than today, so it will be more useful.
    3. The interviewees were animated when they talked about pleasant memories of the past. They said that they often feel lonely because they have no one to talk to, and through the first interview, ATTI, a voice bot that reminisces about the past and evokes pleasant emotions, was born.

 
- Second Interview
    
    The second interview was conducted to help us refine the features of ATTI, the representative character and memory reminiscence voice bot, focusing on the question of how it could further strengthen the connection between patients and their caregivers.
    
    1. We interviewed staff at dementia care centers and found that they were positive about the idea of a solution that relies on voice rather than text. However, we also received feedback from patient caregivers, many of whom are in their 60s and older, that the UX flow should be simplified rather than complicated.
    2. Elderly people with dementia responded positively to the memory recall and verbalization services. However, they tended to have some difficulty with the fact that they were using a smartphone app. Therefore, we tried to implement a user-friendly, large, easy-to-identify UI in warm colors and a simplified UX.

## Solution proposal
To address the challenges faced by people with dementia, ATTI proposes an app to maintain quality of life and promote well-being for people with dementia. 

ATTI is inspired by the "Memory Note", a dementia prevention information provided by the Seoul Dementia Center. The positive effects of a photo reminiscence program for older adults with dementia are shown in the following study.

- According to 'The Effect of Digital Group Reminiscence Program for the Elderly with Mild Dementia' (2023), a digital reminiscence program for the elderly with mild dementia at a dementia day care center showed that the experimental group showed an increase in CIST (Cognitive Impairment Screening Test) results of 5 points out of 30 compared to the control group. In addition, according to the KGDS (Korean Form of Geriatric Depression Scale), both the experimental and control groups showed depressive symptoms with a pre-score of 8 or more, but the experimental group dropped to 6 points afterwards.

---

# What's Different from Before

### GPT to Gemini
- We changed our AI model from GPT to Gemini. By leveraging Gemini's multi-modal capabilities, we were able to create a voicebot that understands and interacts with the photos users submit.

### Simplifying the UI
- Before we started the process of developing top100, we deeply analysed user feedback on past versions. One of the most important feedback we received from users was that the interface was too complicated. Based on this feedback, we improved the UI, focusing on simplifying the design to make it easier for users to understand and use our application.


---

# UN SDGs 3

<img height="300" alt="image" src="https://cdn.imweb.me/upload/S202108243f92708905182/af6401c8a0536.jpg">

---

# Skill


|   Firebase   |    Flutter    |  Gemini 1.5 Pro API  |
|:------------:|:-------------:|:-------------:|
|  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Firebase_Logo.svg/1280px-Firebase_Logo.svg.png" alt="Firebase Logo" width="200"> | <img src="https://modulabs.co.kr/wp-content/uploads/2023/06/flutter-logo-sharing.png" alt="Flutter Logo" width="200"> | <img src="https://miro.medium.com/v2/resize:fit:1200/1*gLJsygEtXnh9ROcbYi-34w.jpeg" alt="Gemini 1.5 Pro API" width="200"> |

---

# Screens

### Home

| Patient | Patient | Patient | Care Giver |
|---------|---------|---------|---------|
| ![KakaoTalk_20240505_235004771](https://github.com/H0ngJu/atti/assets/150149986/35f92048-33ef-4a45-9210-71b8c8a0bae5) | ![KakaoTalk_20240505_235004771_01](https://github.com/H0ngJu/atti/assets/150149986/4454e3d4-4313-41f4-87fc-32101033b6e8) | ![image](https://github.com/H0ngJu/atti/assets/150149986/9b94304e-3dfa-4ae4-a6b7-7824c10e937a) | ![image](https://github.com/H0ngJu/atti/assets/150149986/ee31269b-7d4d-491c-91eb-404636230b07) |

## 🌟Memory Note

### Memory Note Main

| 1 | 2 | 3 | 
|---------|---------|---------|
| ![KakaoTalk_20240505_235417183](https://github.com/H0ngJu/atti/assets/150149986/6d9fa473-0a1c-4d3c-8afc-30bdf540301c) | ![KakaoTalk_20240505_235417183_01](https://github.com/H0ngJu/atti/assets/150149986/277074f8-160f-4353-82a6-df4e0074cdb5) | ![KakaoTalk_20240505_235417183_02](https://github.com/H0ngJu/atti/assets/150149986/8e4dbb5c-0d49-475c-86a0-f46d60cbc4f7) |



### Memory Note registration

| 1 | 2 | 3 | 4 |
|---------|---------|---------|---------|
| ![KakaoTalk_20240505_235922741](https://github.com/H0ngJu/atti/assets/150149986/b864a77d-f2c7-43af-9fb2-b472796e608f) | ![KakaoTalk_20240505_235922741_03](https://github.com/H0ngJu/atti/assets/150149986/a9729b0b-7f00-452c-82ca-3ab3b573c9d9) | ![KakaoTalk_20240505_235922741_04](https://github.com/H0ngJu/atti/assets/150149986/c490cf7b-69cd-48e1-aa74-a31793ed690f) | ![KakaoTalk_20240505_235922741_05](https://github.com/H0ngJu/atti/assets/150149986/33101351-db0b-4f49-9edc-fa8fac48ba1a) |

| 5 | 6 | 7 | 8 |
|---------|---------|---------|---------|
| ![KakaoTalk_20240505_235922741_06](https://github.com/H0ngJu/atti/assets/150149986/33e0e7c3-a094-42c4-b8c6-d6daacb2ed7a) | ![KakaoTalk_20240505_235922741_07](https://github.com/H0ngJu/atti/assets/150149986/edffced2-688a-40d9-8076-289e19c2b336) | ![KakaoTalk_20240505_235922741_08](https://github.com/H0ngJu/atti/assets/150149986/dadb4f14-99f6-4a45-9b97-a0aac1fb312b) | ![KakaoTalk_20240505_235922741_09](https://github.com/H0ngJu/atti/assets/150149986/2ec67e93-9fac-4f46-9bfe-1fd23e7efd86) |



### Conversation with Atti
| 1 | 2 | 3 | 4 |
|---------|---------|---------|---------|
| ![KakaoTalk_20240506_000423586](https://github.com/H0ngJu/atti/assets/150149986/deccd284-057d-42c4-8e1e-d9eae7e4ea66) | ![KakaoTalk_20240506_000423586_01](https://github.com/H0ngJu/atti/assets/150149986/8501882c-adf5-4455-8191-ad3479cb784b) | ![KakaoTalk_20240506_000423586_02](https://github.com/H0ngJu/atti/assets/150149986/1c37bdcf-bd2c-4887-a2e6-3dad7234c628) | ![KakaoTalk_20240506_000423586_03](https://github.com/H0ngJu/atti/assets/150149986/fd5410d4-ba63-4875-9f75-3a2a0f772f1a) |

| 5 | 6 | 7 | 8 |
|---------|---------|---------|---------|
| ![KakaoTalk_20240506_000423586_04](https://github.com/H0ngJu/atti/assets/150149986/1cdccbec-8a53-42e5-8c4a-af9954f32258) | ![KakaoTalk_20240506_000423586_05](https://github.com/H0ngJu/atti/assets/150149986/955def12-a3b8-4a80-8583-a3217b600eee) | ![KakaoTalk_20240506_000423586_06](https://github.com/H0ngJu/atti/assets/150149986/dc7ff95c-633c-4a1b-b4ca-7b9cb5e4bdf8) | ![KakaoTalk_20240506_000423586_07](https://github.com/H0ngJu/atti/assets/150149986/a4b39422-993d-460b-809d-2708032062c0) |



## 🌟Schedule and Routine

### Schedule and Routine Main

| 1 | 2 | 3 | 4 | 5 |
|---------|---------|---------|---------|---------|
| ![KakaoTalk_20240505_234811820](https://github.com/H0ngJu/atti/assets/150149986/22f554ee-05a1-4b95-bab1-1d7644bbb38a) | ![KakaoTalk_20240505_234811820_01](https://github.com/H0ngJu/atti/assets/150149986/11532a86-8f1f-402e-8712-e88b89c8bb9c) | ![KakaoTalk_20240505_234811820_02](https://github.com/H0ngJu/atti/assets/150149986/03848d6a-feeb-4546-998b-a08d1e98f437) | ![KakaoTalk_20240505_235234663](https://github.com/H0ngJu/atti/assets/150149986/f0e90ddc-8867-4cf7-bba2-28e14b957be7) | ![KakaoTalk_20240505_235234663_01](https://github.com/H0ngJu/atti/assets/150149986/ad3f8e64-d59a-4c97-961f-7281bd603369) |



### Schedule registration

| 1 | 2 | 3 | 4 |
|---------|---------|---------|---------|
| ![KakaoTalk_20240505_234639192](https://github.com/H0ngJu/atti/assets/150149986/ab0bbf6b-54e9-42ba-b3a1-e79eadd40225) | ![KakaoTalk_20240505_234639192_01](https://github.com/H0ngJu/atti/assets/150149986/b00a3d05-4475-4f62-8466-d32e0fbcf9f2) | ![KakaoTalk_20240505_234639192_02](https://github.com/H0ngJu/atti/assets/150149986/bf3ea4fe-b941-420f-a946-ad4b90a4c1f9) | ![KakaoTalk_20240505_234639192_03](https://github.com/H0ngJu/atti/assets/150149986/2fc1428b-4328-4c69-8bfb-0f29390bf6a0) |

| 5 | 6 | 7 |
|---------|---------|---------|
| ![KakaoTalk_20240505_234639192_04](https://github.com/H0ngJu/atti/assets/150149986/a1e0e6e6-ff76-4df8-aee0-3f4506ff264f) | ![KakaoTalk_20240505_234639192_05](https://github.com/H0ngJu/atti/assets/150149986/85826abd-afb4-47cb-934a-55a0e66d3f46) | ![KakaoTalk_20240505_234639192_06](https://github.com/H0ngJu/atti/assets/150149986/e6fa665f-bace-4002-9896-cb0567d8ef22) |



### Alert

| 1 | 2 | 3 |
|---------|---------|---------|
| ![KakaoTalk_20240505_235254121](https://github.com/H0ngJu/atti/assets/150149986/2f7314a8-abde-414f-8125-5faff82d48f0) | ![KakaoTalk_20240505_235254121_01](https://github.com/H0ngJu/atti/assets/150149986/41ff455d-2e2b-462f-86c6-a44d46e182a9) | ![KakaoTalk_20240505_235254121_02](https://github.com/H0ngJu/atti/assets/150149986/2921c9b5-4302-454f-9ccc-728a99b0b8df) |




## 🌟Report

### Report

| 1 | 2 | 3 |
|---------|---------|----------|
| <img src="https://github.com/H0ngJu/atti/assets/106425326/e0c2444a-03dc-4ec9-8def-56bc164fad8c" width="200"> | <img src="https://github.com/H0ngJu/atti/assets/106425326/71a664dd-60cf-4dbb-9e79-60b87c341e95" width="200"> | <img src="https://github.com/H0ngJu/atti/assets/106425326/58cfc924-5135-4f7a-8574-02d09ce6265b" width="200"> |



## 🌟 Signup and Login

### Sign Up

| 1 | 2 | 3 |
|---------|---------|----------|
| ![image](https://github.com/H0ngJu/atti/assets/150149986/72dbf55c-dc82-4f29-af0e-4b372066aa69) | ![image](https://github.com/H0ngJu/atti/assets/150149986/8fd14742-5ca6-4633-9fa1-96edb45e197b) | ![image](https://github.com/H0ngJu/atti/assets/150149986/b51a4c1e-6ef9-4086-93dd-cf1640248ad9) |

| 4 | 5 | 6 |
|----------|----------|----------|
| ![image](https://github.com/H0ngJu/atti/assets/150149986/a1ccfaf5-5e8a-49ec-bb70-7f65c6e7c760) | ![image](https://github.com/H0ngJu/atti/assets/150149986/3b51a87e-7b91-43b2-9754-1cda853c8268) | ![image](https://github.com/H0ngJu/atti/assets/150149986/6d6b7d3b-65e0-4df3-a15b-84d71c6c4a55) |






---

# Expected Effect

- Improve emotional stability and quality of life
    - Memory notes can help patients maintain emotional stability by recalling and recording the past, and improve their quality of life through scheduling.
    - Patients' positive emotions can help alleviate the depression caused by dementia and bring a sense of psychological well-being.
- Better care for patient
    - As Korea has become a nuclear family, many elderly households live apart from their children. Even if the caregivers are far away, they can manage the patient's schedule and keep track of the patient's condition.
    - This reduces stress and worry for the caregiver, and provides the patient with an environment where they can maintain their routine and control their life.
- Increased communication and peace of mind
    - Past reminiscences with A.I. allow patients to share a variety of stories, providing them with a new outlet for communication and preventing social isolation.
    - By sharing and communicating their stories, they can maintain their sense of self and strengthen their social relationships.

---

# Closing

'The memories of the past are viewed.'

'Today's memories are recorded for the future.'

This app brings together the past, present, and future of people with dementia.

"Many people think that if you have dementia you have to live in a hopeless state, with no hope and no pleasure, but that's not the case." -Alzheimer's Society, UK

While dementia has been identified as one of the negative aspects of living longer, it is possible to live well as the disease progresses with the right support from those around you.

The 'ATTI' app connects people with dementia to their past, present, and future through positive memory recall, improving their psychological well-being and quality of life. 

We want to realize a future where dementia, which can strike anyone at any time, is not something to be feared, but something to be prepared for.
