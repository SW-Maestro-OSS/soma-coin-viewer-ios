# soma-coin-viewer-ios

소프트웨어 마에스트로 15기에서, Best Practice 용도로 만든 코인뷰어 어플리케이션 입니다.



[링크로 실행하기(Testflight 베타 테스트)↗️](https://testflight.apple.com/join/A66DdpDn)


## 기능 소개

### 웹소켓 스트림

<table>
  <tr>
    <td>
      <b>실시간 코인 가격 변동</b>
    </td>
    <td>
      <b>코인 디테일 정보(오더북테이블, 채결 거래정보)</b>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/1e842b6a-692c-4e77-935c-8114688aa716" width=300 />
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/0a0cff90-b28d-4e5f-b444-029085841b2e" width=300 />
    </td>
  </tr>
</table>

### UI동적 변경

<table>
  <tr>
    <td>
      <b>화폐 동적변경</b>
    </td>
    <td>
      <b>언어 동적변경</b>
    </td>
    <td>
      <b>리스트 타입 동적변경</b>
    </td>
  </tr>
  <tr>
    <td>
       <img src="https://github.com/user-attachments/assets/5cd0509a-e2b2-4692-a1c2-f9bdd1475d7b" width=200 />
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/30b978f1-482f-4add-ba09-182f841f67b2" width=200 />
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/c15a0947-df8f-46d7-b976-1985bc607f72" width=200 />
    </td>
  </tr>
</table>



## 기술 스택

<table>
    <tr>
        <td>
            <b>메인 프레임워크</b>
        </td>
        <td>
            <b>SwiftUI</b>
        </td>
    </tr>
    <tr>
        <td>
            <b>아키텍처</b>
        </td>
        <td>
            <b>클린아키텍처</b>
        </td>
    </tr>
    <tr>
        <td>
            <b>디자인 패턴</b>
        </td>
        <td>
            <b>MVVM</b>
        </td>
    </tr>
    <tr>
        <td>
            <b>외부 의존성</b>
        </td>
        <td>
            <b>Swinject, SimpleImageProvider(자체구현 라이브러리)</b>
        </td>
    </tr>
    <tr>
        <td>
            <b>CI</b>
        </td>
        <td>
            <b>github actions</b>
        </td>
    </tr>
</table>

# How to use

### 방법1: 바로 실행하기

해당 애플리케이션은 테스트 플라이트에 배포되어 있습니다. 아래 링크를 통해 실행가능합니다.

[링크로 실행하기(Testflight 베타 테스트)↗️](https://testflight.apple.com/join/A66DdpDn)

### 방법2: 직접 빌드하기

1. 레포지토리를 다운로드 합니다.
2. `tuist install`을 통해 외부의존성을 install합니다. (Tuist버전: 4.12.1)
3. 요구하는 xcconfig파일을 생성합니다.
4. `tuist generate`를 CLI에 입력합니다.

※ xcconfig파일이 해당 레포지토리에 포함되어 있지않아 따로 생성이 필요합니다. 
  
  (./Secrets/xcconfigs/Release and Debug.xcconfig) **Debug**빌드시 xcconfig파일내 값을 사용하지 않기 때문에 실행시 Debug스킴을 사용하시길 바랍니다.
  
  두 xcconfig파일에 "OPENEX_API_KEY"키값을 할당해야합니다. [환율 API 사이트(Open exchange rates)](https://openexchangerates.org/)의 API_KEY값을 할당해주면 프로젝트가 정상적으로 실행됩니다.
```
OPENEX_API_KEY="API Key for open exchange rates"
```

# Tech features

## Tuist

사용한 이유
- 빌드세팅을 `Swift코드`로 관리
- 프레임워크 `Embed여부` 자동화
- 타겟의 `Mach-O`타입 설정 간편화
- 템플릿을 사용한 모듈 생성
- `tuist graph`를 사용한 의존성 시각화

<img src="./graph.png" width=400 />

## 클린아키텍처

해당 프로젝트는 Presentation, Domain, Data 총 3가지로 이루어진 계층으로 분리되었습니다.

변경 가능성이 높은 UI와 데이터 소스의 경우 Domain계층과 직접적인 의존관계를 지정하지 않고 `protocol`인터페이스를 통해서 가능하도록 설계했습니다.

`protocol`타입의 구현체는 런타임에 의존성을 주입하여, 객체간 유연한 협력이 가능하도록 했습니다.

### 클린아키텍처 / AllMarketTicker화면(메인 화면)

<img src="https://github.com/user-attachments/assets/1e842b6a-692c-4e77-935c-8114688aa716" width=200 />

<table>
  <tr>
    <td>
      <b>레이어</b>
    </td>
    <td>
      <b>책임</b>
    </td>
  </tr>
    <td>
      <b>Presentation</b>
    </td>
    <td>
      <b>텍스트 가공, UI업데이트 주기 관리(throttle)</b>
    </td>
  </tr>
  </tr>
    <td>
      <b>Domain</b>
    </td>
    <td>
      <b>도메인 로직 기반 코인 리스트 가공(가장 거래량이 높은 코인 상위 30개)</b>
    </td>
  </tr>
  </tr>
    <td>
      <b>Data - Repository</b>
    </td>
    <td>
      <b>DTO를 엔티티화</b>
    </td>
  </tr>
  <tr>
      <td>
        <b>Data - DataSource</b>
      </td>
      <td>
        <b>리스트 저장 및 관리(HashMap으로 관리)</b>
      </td>
  </tr>
</table>

### 클린아키텍처 / 코인 디테일 화면

<img src="https://github.com/user-attachments/assets/0a0cff90-b28d-4e5f-b444-029085841b2e" width=200 />

- **(상단) 실시간 오더북 테이블 아키텍처**
<table>
  <tr>
    <td>
      <b>레이어</b>
    </td>
    <td>
      <b>책임</b>
    </td>
  </tr>
    <td>
      <b>Presentation</b>
    </td>
    <td>
      <b>텍스트 가공, UI업데이트 주기 관리(throttle), 테이블 크기 결정</b>
    </td>
  </tr>
  </tr>
    <td>
      <b>Domain</b>
    </td>
    <td>
      <b>테이블 정렬방식 결정(매수가 매도가에 따라 상이), 요청된 테이블 크기로 테이블을 가공</b>
    </td>
  </tr>
  </tr>
    <td>
      <b>Data - Repository</b>
    </td>
    <td>
      <b>DTO를 엔티티화</b>
    </td>
  </tr>
  </tr>
    <td>
      <b>Data - DataSource</b>
    </td>
    <td>
      <b>전체 테이블 저장 및 관리(HashMap으로 관리)</b>
    </td>
  </tr>
</table>

- **(하단) 실시간 코인 거래내역 리스트 아키텍처**

<table>
  <tr>
    <td>
      <b>레이어</b>
    </td>
    <td>
      <b>책임</b>
    </td>
  </tr>
    <td>
      <b>Presentation</b>
    </td>
    <td>
      <b>UI업데이트 주기 관리(throttle), 테이블 크기 결정</b>
    </td>
  </tr>
  </tr>
    <td>
      <b>Domain</b>
    </td>
    <td>
      <b>데이터 업데이트 주기 결정(정보의 최신성 포기), 테이블 정렬방식 결정, 요청받은 테이블 개수로 데이터 가공</b>
    </td>
  </tr>
  </tr>
    <td>
      <b>Data - Repository</b>
    </td>
    <td>
      <b>DTO를 엔티티화</b>
    </td>
  </tr>
  </tr>
    <td>
      <b>Data - DataSource</b>
    </td>
    <td>
      <b>전체 개래내역 테이블을 관리(DTO형태), 전달받은 도메인 로직에 따라 테이블 업데이트 주기를 조절</b>
    </td>
  </tr>
</table>

## 웹소켓 관리 시스템

웹소켓 연결관리는 `WebSocketManagementHelper`객체를 통해서 진행됩니다.

애플리케이션 런칭 이후 시점의 플로우는 아래와 같습니다.

1. AppDelegate에서 앱을 론칭한 이후 `WebSocketManagementHelper`객체를 통해 웹소켓 연결을 시도합니다.
2. 루트 모듈은 일정 시간 동안 의도적으로 딜레이를 발생시켜 유저를 스플래시 화면에 머무르게 합니다. 해당 기간 동안 웹소켓 연결이 대부분 완료됩니다.
3. 각 화면마다 원하는 스트림을 `WebSocketManagementHelper`객체를 통해 구독하고 화면 이탈 시 해제합니다.

전체적인 객체 협력구조는 다음과 같습니다.

<img src="https://github.com/user-attachments/assets/c601dba7-93e9-45fd-995d-167dbdc05097" width=500 />

### 웹소켓 백그라운드 최적화

애플리케이션이 백그라운드로 진입할 경우 웹소켓 연결을 의도적으로 끊습니다.
불필요한 리소스 사용으로 인해 애플리케이션이 시스템에 의해 강제 종료되는 상황을 최대한 배제하기 위해서입니다.
연결 및 해제는 `SceneDelegate`의 생명주기 함수를 통해서 현재 관리되고 있습니다.
웹소켓을 재연결하는 경우 `WebSocketManagementHelper`객체에 캐싱 되어 있던 이전 연결 스트림들이 자연스럽게 복원됩니다.

<img src="https://github.com/user-attachments/assets/0436f88b-0ef2-4353-a135-1f67eb297c2d" width=500 />

### 웹소켓 에러 처리(AlertShooter)

웹소켓이 의도치 않게 끊어지거나 스트림 구독 메시지 전송에 실패한 경우 유저에게 적절한 에러 상황을 표현해야 한다고 판단했습니다.
`WebSocketManagementHelper`객체는 웹소켓 연결 상태 및 메시지 전송 성공 여부에 대한 결과를 수신하고 에러를 발생시킵니다.
하지만 해당 객체는 특정 `ViewModel`에 속한 객체가 아니라 UI를 표시하기 어려운 구조를 지녔습니다.
따라서 `AlertShooter`객체를 통해 View와 `WebsocketHeleper`를 매개하는 방식을 선택했습니다.
`AlertShooter`의 경우 SwiftUI `EnvironmentalObject`로 지정되어 Alert 표시를 희망하는 뷰에서 오류 모델을 수신하여 화면상에 표시합니다.

<img src="https://github.com/user-attachments/assets/1c6dfadb-62e0-46f6-9cdc-1e92bfbc56d5" width=500 />


## 국제화(I18N)

화폐와 언어에 대한 정보는 `I18NManager`객체를 통해서 접근할 수 있습니다.
ViewModel은 `i18NManager`객체를 의존하여 해당 정보를 획득한 후 UI에 적절한 변화를 발생시킵니다.
※ 언어별 텍스트 제공자의 경우 단일체 패턴을 활용하여 접근성을 높이는 선택을 했습니다.

<img src="https://github.com/user-attachments/assets/bd1ecd0a-b120-4e4b-a12f-60c9276b2660" width=500 />
