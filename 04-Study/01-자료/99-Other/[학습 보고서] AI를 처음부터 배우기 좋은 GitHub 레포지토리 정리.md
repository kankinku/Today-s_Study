AI를 처음 시작하거나, 기초부터 체계적으로 다시 다지고 싶은 학습자를 위해  
이론 → 구현 → 실전 → 시스템 설계까지 단계적으로 학습할 수 있는 대표적인 GitHub 레포지토리를 정리하였다.

---

## 1. Neural Networks: Zero to Hero

**제작자:** Andrej Karpathy  
**링크:** [https://github.com/karpathy/nn-zero-to-hero](https://github.com/karpathy/nn-zero-to-hero)

### 핵심 내용

- 신경망을 **완전히 바닥부터 직접 구현**하며 이해하는 강의형 레포지토리
    
- 자동미분, 역전파, MLP, Transformer의 핵심 원리를 코드로 설명
    
- PyTorch를 사용하지만, 내부 동작 원리에 집중
    

### 특징

- 수식보다 **직접 구현을 통한 직관적 이해**에 초점
    
- “왜 이렇게 동작하는가?”를 끝까지 파고드는 구조
    
- AI를 블랙박스가 아닌 **구조물로 이해하고 싶은 학습자**에게 적합
    

---

## 2. Hugging Face Transformers

**제작:** Hugging Face  
**링크:** [https://github.com/huggingface/transformers](https://github.com/huggingface/transformers)

### 핵심 내용

- BERT, GPT, T5 등 **최신 Transformer 모델들의 표준 라이브러리**
    
- 사전학습 모델 로딩, 파인튜닝, 추론까지 실무 중심 구성
    

### 특징

- 자연어 처리(NLP)와 생성형 AI의 **사실상 표준**
    
- 연구·산업 현장에서 가장 많이 사용됨
    
- “직접 모델을 만들어 쓰는 단계”로 넘어가기 위한 필수 레포
    

---

## 3. fastbook (FastAI)

**제작:** fastai  
**링크:** [https://github.com/fastai/fastbook](https://github.com/fastai/fastbook)

### 핵심 내용

- 『Practical Deep Learning for Coders』 교재 기반 레포지토리
    
- 최소한의 수학으로 **빠르게 성과를 내는 딥러닝 실습 중심**
    

### 특징

- 이미지, 텍스트, 추천 시스템 등 다양한 문제를 빠르게 경험
    
- “이론보다 결과 → 이후 원리 설명” 방식
    
- AI 입문자에게 **성공 경험을 빠르게 제공**
    

---

## 4. Made With ML

**제작:** Made With ML  
**링크:** [https://github.com/GokuMohandas/Made-With-ML](https://github.com/GokuMohandas/Made-With-ML)

### 핵심 내용

- 머신러닝 모델을 **실제 서비스로 만드는 전체 과정**
    
- 데이터 수집 → 전처리 → 학습 → 배포 → 모니터링까지 포함
    

### 특징

- 단순 모델 학습을 넘어서 **MLOps 개념까지 포괄**
    
- 실무 지향적 구조
    
- “AI 개발자”가 아닌 **“ML 엔지니어”를 목표로 할 때 적합**
    

---

## 5. Machine Learning Systems Design

**제작자:** Chip Huyen  
**링크:** [https://github.com/chiphuyen/machine-learning-systems-design](https://github.com/chiphuyen/machine-learning-systems-design)

### 핵심 내용

- 대규모 ML 시스템을 설계할 때 고려해야 할 요소 정리
    
- 데이터 분포 변화, 성능 저하, 비용, 확장성 문제 다룸
    

### 특징

- 모델 성능보다 **시스템 전체 관점**에 집중
    
- 실제 기업 환경에서 발생하는 문제 중심
    
- 중급 이상 학습자에게 적합
    

---

## 6. Awesome Generative AI Guide

**제작:** aishwaryanr  
**링크:** [https://github.com/aishwaryanr/awesome-generative-ai-guide](https://github.com/aishwaryanr/awesome-generative-ai-guide)

### 핵심 내용

- 생성형 AI 관련 자료를 **주제별로 큐레이션**
    
- LLM, 이미지 생성, 에이전트, RAG 등 광범위한 링크 모음
    

### 특징

- 하나의 교재가 아닌 **로드맵·참고서 역할**
    
- 최신 트렌드 파악에 유용
    
- 학습 중간중간 참고 자료로 활용하기 좋음
    

---

## 7. Dive into Deep Learning (D2L)

**제작:** D2L.ai  
**링크:** [https://github.com/d2l-ai/d2l-en](https://github.com/d2l-ai/d2l-en)

### 핵심 내용

- 딥러닝 이론과 구현을 함께 다루는 **정통 교과서형 레포**
    
- 수식, 이론, PyTorch 코드가 체계적으로 연결됨
    

### 특징

- 대학 전공 수준의 깊이
    
- CNN, RNN, Attention, Transformer 전반을 포괄
    
- 이론 기반을 탄탄히 다지고 싶은 학습자에게 적합
    

---

## 정리: 추천 학습 흐름

1. **개념 직관 형성**  
    → Neural Networks: Zero to Hero
    
2. **빠른 실습과 자신감 확보**  
    → fastbook
    
3. **이론 체계 정립**  
    → Dive into Deep Learning
    
4. **실무 모델 활용**  
    → Hugging Face Transformers
    
5. **서비스·시스템 관점 확장**  
    → Made With ML, ML Systems Design
    
6. **트렌드 탐색 및 확장**  
    → Awesome Generative AI Guide