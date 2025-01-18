# soma-coin-viewer-ios

소프트웨어 마에스트로 15기에서, Best Practice 용도로 만든 코인뷰어 어플리케이션 입니다.

<table>
  <tr>
    <td>
      <b>웹소켓 데이터 수신 및 표출</b>
    </td>
    <td>
      <b>코인가격 표시화폐 동적변경</b>
    </td>
    <td>
      <b>언어 동적변경</b>
    </td>
    <td>
      <b>코인표츌UI 동적변경</b>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/227bc448-0e8b-40df-bca6-9c0f742b011c" width=200 />
    </td>
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
            <b>MVVM, MVI(단방향 플로우)</b>
        </td>
    </tr>
    <tr>
        <td>
            <b>외부 의존성</b>
        </td>
        <td>
            <b>Swinject</b>
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

해당 프로젝트는 다운로드 후 실행할 수 있습니다.

1. 레포지토리를 다운로드 합니다.
2. `tuist install`을 통해 외부의존성을 install합니다.
3. 요구하는 xcconfig파일을 생성합니다.
4. `tuist generate`를 CLI에 입력합니다.

※ xcconfig파일이 해당 레포지토리에 포함되어 있지않아 따로 생성이 필요합니다. 
  
  (./Secrets/xcconfigs/Release and Debug.xcconfig) **Debug**빌드시 xcconfig파일내 값을 사용하지 않기 때문에 실행시 Debug스킴을 사용하시길 바랍니다.
  
  두 xcconfig파일에 "OPENEX_API_KEY"키을 할당해야합니다. [환율 API 사이트(Open exchange rates)](https://openexchangerates.org/)의 API_KEY값을 할당해주면 프로젝트가 정상적으로 실행됩니다.
```
OPENEX_API_KEY="API Key for open exchange rates"
```

# Tech features

## 웹소켓과 클린아키텍처

soma-coin-viewer앱은 현재 `Binance API`를 사용합니다. 하지만 WebSocketService 및 Repository는 클린아키텍처를 따르는 추상화된 객체로 구체타입 변경을 통해 다른 API에도 대응이 가능합니다.

## 웹소켓 연결

웹소켓연결은 다소 시간이 걸리는 작업으로 특정화면 진입 후 연결 시도시 TTI가 오래걸리게됩니다. 따라서 `WebSocketManagementHelper`객체에게 웹소켓 연결과 스트림 관리 책임을 수행하도록 합니다.

웹소켓의 연결은 앱이 론칭시 곧바로 진행됩니다. (이를 위해 스플래쉬 화면을 의도적으로 2초동안 표출되도록 설정했습니다.)

`WebSocketManagementHelper`객체로 해당 책음을 분리함으로써 **어플리케이션의 상태에 따른 웹소켓 연결 관리**를 효과적으로 처리했습니다.

해당 객체는 최근까지 구독했던 스트림에 대한 정보를 관리함으로써 재연결 후에 연결이 해제되기 직전까지 진행중인던 작업을 완벽하게 복원합니다.

<img src="https://github.com/user-attachments/assets/1c1000d7-c1b3-4494-85f9-98ef53169823" width=700 />


`WebSocketManagementHelper`객체와 협력하는 객체들은 아래 그림처럼 협력하게 됩니다.

<img src="https://github.com/user-attachments/assets/527cf558-7148-4cf0-bcff-8063fd6fb976" width=700 />


※ Presentation --> WebSocketManagementHelper 메세지중 **데이터 스트림**이란 웹소켓 API에게 구독을 요청하는 스트림을 의미합니다. (Ex, all market tickers, orderbook)
