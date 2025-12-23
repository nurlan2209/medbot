# medbot (MedBot)

Flutter iOS app + Node/Express backend (JWT + MongoDB + Gemini).

## Backend (server)

- Create `server/.env` from `server/.env.example`

### Option A: Docker (recommended)

- From repo root: `docker compose up -d --build`

### Option B: Local Node

- Install deps: `cd server && npm i`
- Run: `cd server && node index.js`

## App (Flutter iOS)

Your iPhone app must call the backend by IP/port (not `localhost`).

- Run with base URL: `flutter run --dart-define=API_BASE_URL=http://<SERVER_IP>:3001`
