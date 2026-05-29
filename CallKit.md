# CallKit — możliwości i ograniczenia

## Co to jest CallKit

CallKit to framework Apple'a umożliwiający integrację połączeń VoIP z natywnym interfejsem telefonicznym iOS. Pozwala też zewnętrznym aplikacjom **obserwować** stan połączeń na urządzeniu.

---

## Obserwacja połączeń — co możemy wykryć

### `CXCallObserver` — obserwacja stanu połączeń

| Co możemy wykryć | Dostępne |
|---|---|
| Czy trwa aktywne połączenie | ✅ |
| Czy połączenie jest przychodzące / wychodzące | ✅ (`isOutgoing`) |
| Czy połączenie jest wstrzymane (hold) | ✅ (`isOnHold`) |
| Czy połączenie zostało odebrane | ✅ (`hasConnected`) |
| Czy połączenie zostało zakończone | ✅ (`hasEnded`) |
| Unikalny identyfikator połączenia (UUID) | ✅ |
| Numer telefonu rozmówcy | ❌ |
| Imię / nazwisko rozmówcy | ❌ |
| Czas trwania połączenia | ❌ |
| Aplikacja, przez którą trwa połączenie | ❌ |

### Które połączenia są widoczne

`CXCallObserver` widzi wyłącznie połączenia zgłoszone do systemu przez CallKit. Oznacza to:

| Źródło połączenia | Wykrywalne przez `CXCallObserver` |
|---|---|
| Natywne połączenie telefoniczne | ✅ |
| FaceTime (audio i wideo) | ✅ |
| WhatsApp | ✅ |
| Telegram | ✅ |
| Signal | ✅ |
| Microsoft Teams | ✅ |
| Zoom | ✅ |
| Aplikacje VoIP bez integracji z CallKit | ❌ |

---

## Uprawnienia

### Samo wykrywanie aktywnych połączeń (`CXCallObserver`)

**Nie wymaga żadnych dodatkowych uprawnień.** Wystarczy `import CallKit` — bez wpisów w `Info.plist`, bez Capabilities, bez zgody użytkownika.

### Kiedy poszczególne uprawnienia są potrzebne

| Uprawnienie | Gdzie | Kiedy potrzebne |
|---|---|---|
| Push Notifications capability | Xcode → Signing & Capabilities | Tylko gdy aplikacja **sama odbiera** VoIP pushe (`PKPushRegistry`) |
| Background Modes → Voice over IP | Xcode → Signing & Capabilities | Tylko gdy aplikacja **sama obsługuje** połączenia VoIP w tle |
| `NSMicrophoneUsageDescription` | `Info.plist` | Tylko gdy aplikacja **sama obsługuje** audio połączeń |

### Działanie w tle

`CXCallObserver` nie otrzymuje callbacków gdy aplikacja jest uśpiona przez iOS — ale nie jest to problem przy wyświetlaniu UI. Właściwość `isOnCall` czyta stan bezpośrednio z `callObserver.calls`, więc zawsze zwraca aktualną wartość w momencie gdy użytkownik wróci do aplikacji.

---

## Ograniczenia prywatności

Apple celowo nie udostępnia tożsamości rozmówcy przez publiczne API. Dotyczy to zarówno:
- natywnych połączeń telefonicznych,
- połączeń z zewnętrznych aplikacji (WhatsApp, Telegram itp.).

Numer/imię rozmówcy jest dostępne **wyłącznie** gdy Twoja aplikacja sama jest stroną połączenia i kontroluje jego nawiązanie (np. własna aplikacja VoIP raportująca połączenie przez `CXProvider`).

---

## Podsumowanie — zakres `CXCallObserver`

```
CXCallObserver odpowiada na pytanie:
  "Czy teraz trwa połączenie i w jakim jest stanie?"

CXCallObserver NIE odpowiada na pytanie:
  "Z kim trwa to połączenie?"
```
