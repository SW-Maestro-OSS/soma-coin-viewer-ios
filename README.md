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
