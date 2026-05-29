# Flow — weryfikacja połączenia telefonicznego

## Scenariusz 1: Dzwoni bank

```
Telefon użytkownika                App bankowa                  Backend banku           System call center
        │                               │                               │                       │
        │  Przychodzące połączenie       │                               │                       │
        │──────────────────────────────▶│                               │                       │
        │                               │                               │                       │
        │                        CXCallObserver                         │                       │
        │                        wykrywa połączenie                     │                       │
        │                               │                               │                       │
        │                               │  GET /calls/active            │                       │
        │                               │  Authorization: Bearer <token>│                       │
        │                               │──────────────────────────────▶│                       │
        │                               │                               │  czy dzwonicie         │
        │                               │                               │  do klienta X?        │
        │                               │                               │──────────────────────▶│
        │                               │                               │                       │
        │                               │                               │◀──────────────────────│
        │                               │                               │  tak, agent: Jan K.   │
        │                               │                               │                       │
        │                               │◀──────────────────────────────│                       │
        │                               │  { verified: true,            │                       │
        │                               │    agentName: "Jan K." }      │                       │
        │                               │                               │                       │
        │                        ┌──────────────┐                       │                       │
        │                        │  ✅ To jest  │                       │                       │
        │                        │  połączenie  │                       │                       │
        │                        │  z banku     │                       │                       │
        │                        │  Agent: Jan K│                       │                       │
        │                        └──────────────┘                       │                       │
```

---

## Scenariusz 2: Dzwoni oszust podający się za bank

```
Telefon użytkownika                App bankowa                  Backend banku           System call center
        │                               │                               │                       │
        │  Przychodzące połączenie       │                               │                       │
        │──────────────────────────────▶│                               │                       │
        │                               │                               │                       │
        │                        CXCallObserver                         │                       │
        │                        wykrywa połączenie                     │                       │
        │                               │                               │                       │
        │                               │  GET /calls/active            │                       │
        │                               │  Authorization: Bearer <token>│                       │
        │                               │──────────────────────────────▶│                       │
        │                               │                               │  czy dzwonicie         │
        │                               │                               │  do klienta X?        │
        │                               │                               │──────────────────────▶│
        │                               │                               │                       │
        │                               │                               │◀──────────────────────│
        │                               │                               │  nie                  │
        │                               │                               │                       │
        │                               │◀──────────────────────────────│                       │
        │                               │  { verified: false }          │                       │
        │                               │                               │                       │
        │                        ┌──────────────┐                       │                       │
        │                        │  ⚠️  Bank    │                       │                       │
        │                        │  NIE dzwoni  │                       │                       │
        │                        │  do Ciebie   │                       │                       │
        │                        │  w tej chwili│                       │                       │
        │                        └──────────────┘                       │                       │
```

---

## Scenariusz 3: Race condition — zapytanie wyprzedza rejestrację w call center

```
        │                               │                               │                       │
        │  Połączenie                   │                               │                       │
        │──────────────────────────────▶│                               │  (call center         │
        │                               │──── GET /calls/active ───────▶│   jeszcze nie         │
        │                               │                               │   zarejestrowało)     │
        │                               │◀─── { verified: false } ──────│                       │
        │                               │                               │                       │
        │                               │  retry po 2s                  │                       │
        │                               │──── GET /calls/active ───────▶│                       │
        │                               │                               │──────────────────────▶│
        │                               │                               │◀──────────────────────│
        │                               │                               │  tak                  │
        │                               │◀─── { verified: true } ───────│                       │
        │                        ┌──────────────┐                       │                       │
        │                        │  ✅ To jest  │                       │                       │
        │                        │  połączenie  │                       │                       │
        │                        │  z banku     │                       │                       │
        │                        └──────────────┘                       │                       │
```
