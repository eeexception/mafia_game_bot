# Mafia Party Game System

A professional, hybrid system for automating the "Mafia" party game in offline settings. This project acts as a **Digital Game Master**, ensuring rule compliance, vote management, timing, and atmospheric audio accompaniment.

## 🚀 Architecture

The system consists of two primary components:

*   **Host (Desktop Application)**: Built with Flutter Desktop (macOS/Windows/Linux). It serves as the central server and main display (TV/Projector), managing the game state, audio, and participant connections.
*   **Client (Player Controller)**: A mobile-optimized PWA (Progressive Web App) built with Flutter Web. Players connect via their smartphones to receive roles, perform secret actions, and participate in voting.

## 🛠 Technology Stack

*   **Framework**: Flutter (Dart)
*   **State Management**: Riverpod (with MVC + Clean Architecture)
*   **Networking**:
    *   **HTTP Server**: `shelf` (Host serves the PWA static files locally)
    *   **Real-time Co-op**: `web_socket_channel` (Bi-directional game state synchronization)
*   **Storage**: `hive` (Local database for persistent statistics)
*   **Audio**: `audioplayers` (Dynamic audio engine with ducking and randomization)
*   **Utilities**: `qr_flutter`, `uuid`, `wakelock_plus`, `yaml`, `freezed`

## ✨ Key Features

*   **Advanced Game Mechanics**:
    *   **Don & Prostitute Logic**: Specialized interaction where the Don can protect the Mafia from individual blocks.
    *   **Mafia Blind Mode**: Gesture-based communication requiring 100% consensus for kills.
    *   **"Vote Early" System**: Social consensus mechanism to skip discussion timers when all players are ready.
*   **Dynamic Theming Engine**: Switch role names, randomized audio announcements, and background music via YAML configurations without rebuilding.
*   **Persistent Statistics**: Tracks win rates by faction, role frequency, and game duration.
*   **Professional Host UI**: Optimized for large screens with animated phase indicators, real-time vote visualization, and public event logs.
*   **Mobile-First Client UI**: Dark mode optimized to minimize screen glow during night phases, featuring press-to-reveal role cards and WakeLock support.
*   **Log Management**: Comprehensive public logs during the game and detailed secret logs (role actions, votes) exportable as `.txt` after completion.

## 🎭 Roles & Factions

### Civilian Faction (Town)
*   **Civilian**: The majority of the town. Goal: Identify and execute all Mafia and the Maniac.
*   **Commissar (Detective)**: Each night, investigates one player to see if they are Mafia.
*   **Sergeant**: Assistant to the Commissar. Receives investigation results and takes over if the Commissar dies.
*   **Doctor**: Each night, selects one player to heal. If that player is attacked, they survive.
*   **Prostitute (Blocker)**: Each night, visits a player. If that player is an active role, their action is cancelled.

### Mafia Faction
*   **Mafia**: Each night, the team votes on a victim. 
*   **Don (Leader)**: The head of the Mafia. If "Don Mechanics" is on, the Don has exclusive authority to choose the kill target (or investigate if search mode is on). If the Don dies, the role is automatically transferred to another random living Mafia member.
*   **Lawyer**: Mafia's spy. Each night, investigates a player to see if they are an active Town role (Commissar/Sergeant).

### Neutral Roles
*   **Maniac**: A solo killer. Wins by being the last survivor or reaching a 1v1 state with any civilian.
*   **Poisoner**: A neutral role with a high-risk trap. When the Poisoner "visits" a target, they leave a toxin. The target dies immediately, and anyone else who interacts with that target (Heal, Check, Block) also dies.

---

## ⚙️ Game Settings

### Role Toggles
*   **Commissar/Doctor/Prostitute/Maniac/Sergeant/Lawyer/Poisoner**: Enable or disable specific roles. Even core roles like the Commissar and Doctor can now be toggled off for specific game variants.
*   **Auto-pruning Roles**: 
    *   *ON (Default)*: Roles are skipped if player count is too low (e.g. Maniac needs 9+). Hints in setup.
    *   *OFF*: Forced inclusion of toggled roles.
*   **Mafia Dynamics**:
    *   **Don Mechanics**: 
        *   *ON*: Don controls kills (or checks). Lawyer investigates.
        *   *OFF*: Mafia shoots by consensus (100% agreement required).
    *   **Don Action**: Choose whether the Don performs a Kill or a Search (finding the Commissar).
*   **Advanced Role Settings**:
    *   **Commissar Can Kill**: In this mode, the Commissar (and Sergeant) perform kills instead of investigations.
    *   **Doctor Settings**: Toggle whether the Doctor can heal themselves or the same target two nights in a row.
*   **Vote Early**: In the Day Discussion, if all living players press "Ready to Vote", the timer skips to the voting phase.

---

## 📂 Project Structure

Following a strict **MVC + Clean Architecture** pattern:

```text
lib/
├── core/
│   ├── models/          # Immutable data entities (Player, Role, GameState)
│   ├── controllers/     # Business logic & State machines (GameController, AudioController)
│   ├── services/        # Infrastructure (WebSocketServer, HttpServer, Storage)
│   └── state/           # Riverpod providers
├── ui/
│   ├── host/            # Desktop-specific screens and widgets
│   ├── client/          # Mobile web-specific screens and widgets
│   └── shared/          # Common components and theme constants
├── main_host.dart       # Host application entry point
└── main_client.dart     # Client PWA entry point
```

### Notable Core Controllers/Services

*   **GameController**: Orchestrates state transitions and delegates to core flow services.
*   **NightFlowService**: Night readiness, immediate actions, resolution, and announcements.
*   **VotingService**: Ready-to-vote, day votes, and verdict processing.
*   **SessionService**: Session id generation and join validation.
*   **RoleDistributionService**: Role distribution and balancing rules.

## 📚 Design Docs

*   Class diagram: `docs/CLASS_DIAGRAM.md`
*   Flow diagrams: `docs/flow/`

## ⚙️ Getting Started

### Prerequisites

*   Flutter SDK (Latest Stable)
*   Dart SDK (Latest Stable)
*   For macOS Host: Xcode installed
*   A local network (Wi-Fi) shared between Host and Clients

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/eeexception/MafiaGameBot.git
    cd MafiaGameBot/mafia_game
    ```

2.  Install dependencies:
    ```bash
    flutter pub get
    ```

3.  Generate model serialization code:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

## 🏃 Running the Application

### 1. Launch the Host (Desktop)

The Host must be started first as it hosts the web server for clients.

```bash
# Run on macOS (MVP)
flutter run -t lib/main_host.dart -d macos

# Run on Windows
flutter run -t lib/main_host.dart -d windows
```

The Host will display a **QR Code**. Players should scan this to join.

### 2. Run/Access the Client (Web)

For development/testing, you can run the client locally:

```bash
flutter run -t lib/main_client.dart -d chrome
```

In a real game, the Host serves the built PWA. To prepare the client for the Host:

```bash
flutter build web -t lib/main_client.dart --web-renderer canvaskit
```
The Host automatically looks for the web build in the `build/web` directory (ensure pathing in `HttpServerService` is correct).

## 🔨 Building for Production

### macOS Application
```bash
flutter build macos -t lib/main_host.dart
```

### PWA (Web)
```bash
flutter build web -t lib/main_client.dart --release
```

## 🧪 Testing & Quality

We follow **Test Driven Development (TDD)** and maintain zero static analysis warnings.

### Run Unit Tests
```bash
flutter test
```

### Run Integration Tests
Verifies the full Host workflow (Lobby -> Setup).
```bash
flutter test -d macos integration_test/full_game_flow_test.dart
```

### Static Analysis
```bash
flutter analyze
```

## 📜 Specifications & Nuances

*   **WebSocket Protocol**: All communication is JSON-based. Clients identify via a unique device ID and session token to survive disconnections.
*   **Audio System**: Announcement events duck the background music volume. Random variants are picked from the `config.yaml` to keep the atmosphere fresh.
*   **Secrecy Integrity**: Role information is stored only on the Host. The Client PWA only receives its specific role. Detailed logs are encrypted/hidden until the game concludes.
*   **Networking**: Both Host and Client must be on the **same Wi-Fi network**. The Host uses the local IP (e.g., `192.168.1.50`) for the QR code.

## 🎨 Theme Management

Themes allow you to customize role names, audio announcements, and background music.

### Theme Structure
Themes are located in the `themes/` directory. A theme consists of:
1.  `config.yaml`: Configuration file defining role names and audio mappings.
2.  `assets/`: Directory containing audio files (`.mp3`).

### Creating a New Theme
1.  Duplicate the `themes/default/` folder.
2.  Rename the folder (e.g., `themes/cyberpunk/`).
3.  Update `config.yaml` with the new theme ID, name, and audio mappings.
4.  Add your custom audio files to `themes/cyberpunk/assets/`.
5.  Register the new theme path in `pubspec.yaml` under `assets`:
    ```yaml
    assets:
      - themes/cyberpunk/
      - themes/cyberpunk/assets/
    ```

---
**Status**: Production Ready  
**Version**: 1.0.0  
**License**: GNU GPL v3
