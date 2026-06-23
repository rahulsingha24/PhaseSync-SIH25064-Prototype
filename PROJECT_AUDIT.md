# Project Audit Report

## 1. Project Identity

* **Project/App Name**: `sih2k25_app` (Internal/Package Name), **PhaseSync** (Display/UI Name, found in `lib/main.dart`).
* **Type of Project**: Cross-platform Mobile Application Prototype.
* **Platform**: Android/iOS/Web (created primarily for mobile, currently built for Android).
* **Framework Used**: Flutter (Version 3.41.2).
* **Programming Languages Used**: Dart (v3.11.0), Kotlin (Android platform-specifics).
* **Package Manager Used**: Pub (Flutter's default package manager).
* **Current Application Version**: `0.1.0+1` (identified from `pubspec.yaml`).
* **Android Package/Application ID**: `com.example.sih2k25_app` (identified from `android/app/build.gradle.kts`).
* **Minimum and Target Android SDK Versions**: Relying on Flutter defaults (`flutter.minSdkVersion` and `flutter.targetSdkVersion` in `build.gradle.kts`). The `flutter_launcher_icons` plugin enforces a minimum SDK of `21` (Android 5.0).
* **Created With**: Flutter.

## 2. Complete Technology Stack

| Technology | Name | Status |
| :--- | :--- | :--- |
| **Frontend Framework** | Flutter | Genuinely implemented |
| **UI/CSS Framework** | Material Design | Genuinely implemented (built into Flutter) |
| **Mobile Wrapper** | None | N/A (Native Flutter compilation) |
| **Backend** | None | Unused (No backend logic present) |
| **Database** | None | Unused |
| **Authentication** | None | Unused |
| **Cloud Services** | None | Unused |
| **State Management** | Provider (`^6.1.1`) | Genuinely implemented (`ThemeProvider`, `SimulationProvider`) |
| **Charts/Visuals** | FL Chart (`^0.66.0`) | Genuinely implemented (used in Analytics Screen) |
| **Icons & Fonts** | Google Fonts, Launcher Icons | Genuinely implemented |
| **Hardware Connectivity**| Bluetooth/Wi-Fi/Serial | Unused (Mocked internally) |

## 3. Project Folder Structure

```text
sih2k25_app/
├── android/            # Android-specific native code and build configurations
│   ├── app/            # Application module (contains build.gradle.kts, src)
│   └── build.gradle.kts# Project-level Android build configuration
├── assets/             # Static assets like images or custom fonts (contains icon.png)
├── ios/                # iOS-specific native code and build configurations
├── lib/                # Main Dart source code folder
│   ├── models/         # Data classes (alert.dart, load_appliance.dart)
│   ├── providers/      # State management logic (simulation_provider.dart, theme_provider.dart)
│   ├── screens/        # UI Views (dashboard, analytics, settings, etc.)
│   ├── main.dart       # Application entry point
│   └── theme.dart      # Application styling and color definitions
├── linux/, macos/, web/, windows/ # Other platform runners
├── pubspec.yaml        # Flutter package and dependency manifest
└── .gitignore          # Git exclusion rules
```

**Folder/File Explanations**:
* `lib/`: Contains the core application logic. Everything the user sees and interacts with is built here using Dart.
* `lib/providers/simulation_provider.dart`: The core "brain" of this prototype, replacing a real backend with random number generators and simulated solar/battery logic.
* `android/`: Holds the native wrapper required to compile the Dart code into an Android APK.

## 4. Installation and Running Instructions

**Required Software**:
* Flutter SDK (`^3.11.0` or higher)
* Dart SDK (included with Flutter)
* Android Studio (with Android SDK installed) or VS Code

**Commands to Run from a Fresh Computer**:
1. **Dependency Installation**: `flutter pub get`
2. **Development Command (Emulator/Device)**: `flutter run`
3. **Android APK Build Command**: `flutter build apk` (or `flutter build apk --release` for a production build)
4. **Web Build Command**: `flutter build web`

*Note: No environment variables or complex setup are required since there are no external API integrations.*

## 5. Application Screens and Navigation

* **DashboardScreen (`/` via MainShell)**: Purpose: Home view showing real-time (mocked) solar, battery, and grid status. Contains Tri-Node Diagram, status cards. Completely mocked data.
* **AnalyticsScreen (Trends Tab)**: Purpose: Shows line charts of historical power usage. Fully mocked using FL Charts.
* **ControlPanelScreen (Devices Tab)**: Purpose: Allows user to toggle connected appliances. UI is fully working, but state is held only in memory (SimulationProvider).
* **SettingsScreen (Settings Tab)**: Purpose: Modifies battery thresholds and notification toggles. UI works, changes persist in memory only.
* **AlertsScreen (Appbar Icon)**: Purpose: Displays system notifications and warnings. Fully driven by simulated events.

**User Journey**: The user opens the app to `MainShell`, seeing the `DashboardScreen` by default. They can observe simulated power flowing between solar, grid, and home. They navigate via the Bottom Navigation Bar to view historical trends, manually toggle appliances in the Devices tab, or adjust app behavior in Settings. 

## 6. Feature Audit

| Feature | Intended Purpose | Current Status | Real or Mocked | Files Responsible | Problems/Limitations |
| :--- | :--- | :--- | :--- | :--- | :--- |
| System Status | Show if solar/grid is active | Working | Mocked | `dashboard_screen.dart`, `simulation_provider.dart` | No real sensors connected |
| Charts/Trends | Show power analytics over time | Working | Mocked | `analytics_screen.dart`, `simulation_provider.dart` | Data resets on app restart |
| Device Toggles | Turn on/off appliances | Working | Mocked | `control_panel_screen.dart` | Does not control real hardware |
| Notifications | Warn about low battery/grid usage | Working | Mocked | `simulation_provider.dart`, `alerts_screen.dart` | Only in-app, no real push notifications |
| Theme Toggle | Switch Light/Dark mode | Fully Working | Real | `theme_provider.dart`, `theme.dart` | None |

## 7. Backend and Database Audit

**The project DOES NOT have a real backend or database.**
* **Storage type**: In-memory state only (`SimulationProvider`).
* **Persistence**: None. If the app is closed and reopened, all data, alerts, and settings reset to their default states.
* **Authentication**: None.
* **APIs**: No external REST or GraphQL APIs are called.

All real-time functionality is powered by a `Timer.periodic` loop inside `lib/providers/simulation_provider.dart` which generates random wattage values every 3 seconds to simulate a live energy grid.

## 8. Hardware Integration Audit

This app was intended to support a hardware-based SIH prototype (like an ESP32 or Bluetooth sensors).
* **Current Status**: **Completely Absent**.
* **Simulation**: Simulated entirely via `simulation_provider.dart`.
* **Bluetooth/Wi-Fi/Serial/MQTT**: No libraries or implementations exist in the codebase for these protocols.

If real hardware integration is desired in the future, the `SimulationProvider` must be gutted and replaced with a real MQTT client, WebSocket connection, or Bluetooth LE listener.

## 9. Permissions Audit

The application requests only default minimal permissions out of the box.
* **Internet**: Implicitly added by Flutter for debug builds, not explicitly defined in `AndroidManifest.xml`.
* **Bluetooth/Location/Camera**: Not requested.
* **Privacy/Play Store Concerns**: None. The app is entirely self-contained and safe.

## 10. Problems and Incomplete Work

**High Priority (Core Prototype Gaps)**:
* Missing Backend & Database: Data is entirely ephemeral.
* Hardware Integration Gaps: No actual connectivity code exists; it cannot talk to an ESP32 or sensor array yet.

**Medium Priority**:
* Real Push Notifications: Alerts are currently just in-app lists.
* Authentication: No user login system exists.

## 11. Final Project Status

**Classification: UI / Functional Prototype**
* **Why**: The UI is fully built out, responsive, and contains complex state management (via Provider) that gives the illusion of a fully working system. The simulation logic is robust enough for a live pitch or demo.
* **Portfolio Use**: It is highly suitable for demonstrating UI/UX design, Flutter architecture (Provider, FL Chart), and conceptualizing an IoT dashboard. It cannot be demonstrated as a working hardware controller.
