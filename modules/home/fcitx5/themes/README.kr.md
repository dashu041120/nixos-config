<img src="https://gw.alipayobjects.com/zos/antfincdn/R8sN%24GNdh6/language.svg" width="18"> [<span>:cn:</span>](./README.md) | [<span>:jp:</span>](./README.jp.md) | [<span>:us:</span>](./README.en.md)

# Candlelight

fcitx5에 대한 커스텀 스킨으로, fcitx5-rime에서 테스트되었습니다.

## 개요

### 백그라운드 강조 시리즈

- **Spring**
  ![fcitx5 봄 테마](images/1606626556.png)
- **Summer**
  ![fcitx5 여름 테마](images/1606805712.png)
- **Autumn**
  ![fcitx5 가을 테마](images/1606805738.png)
- **Winter**
  ![fcitx5 겨울 테마](images/1606805676.png)

### 후보 강조 시리즈

- **Green**
  ![fcitx5 초록 테마](images/1607336476.png)
- **Transparent Green**
  ![fcitx5 투명 초록 테마](images/1607338718.png)

### macOS에서 영감을 얻은 테마들

- **macOS Light**
  ![macOS 라이트 테마](images/mac-light.png)
  - 원래 macOS 소노마 라이트:
    ![macOS 소노마 라이트](images/macOS%20Sonoma%20Light.png)
- **macOS Dark**
  ![macOS 다크 테마](images/mac-dark.png)
  - 원래 macOS 소노마 다크:
    ![macOS 소노마 다크](images/macOS%20Sonoma%20Dark.png)

## 사용법

1. 저장소를 클론합니다:

   ```bash
   git clone https://github.com/thep0y/fcitx5-themes.git
   ```

2. 원하는 테마를 적절한 디렉토리로 복사합니다:

   ```bash
   cd fcitx5-themes
   cp -r <theme-name> ~/.local/share/fcitx5/themes
   ```

3. 테마 설정을 구성합니다:

   ```bash
   vim ~/.config/fcitx5/conf/classicui.conf
   ```

   다음 줄들을 추가합니다 (필요에 따라 폰트를 조정할 수 있습니다):

   ```apacheconf
   Vertical Candidate List=False
   PerScreenDPI=True
   Font="Smartisan Compact CNS 13"
   Theme=<theme-name>
   ```

4. fcitx5-rime에서 단일 줄 모드를 구성합니다:

   ```bash
   vim ~/.config/fcitx5/conf/rime.conf
   ```

   다음을 추가합니다:

   ```apacheconf
   PreeditInApplication=True
   ```

5. 변경 사항을 적용하기 위해 fcitx5를 재시작합니다.

사용 가능한 테마는 다음과 같습니다:

- **spring**
- **summer**
- **autumn**
- **winter**
- **green**
- **transparent-green**
- **macOS-light**
- **macOS-dark**

단일과 이중 줄 (예비 입력) 모드 사이를 전환하려면 단축키 `<Ctrl>+<Alt>+P`를 사용합니다.

---

macOS와 Windows용 더 많은 테마를 탐색하세요:

- [Rime 98 테마](https://github.com/thep0y/rime-98/tree/master/themes)

