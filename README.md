# PhaseSync

A Flutter mobile application prototype developed for our Smart India Hackathon 2025 college internal-round project.

## Download Android App

[**Download the latest PhaseSync APK**](https://github.com/rahulsingha24/PhaseSync-SIH25064-Prototype/releases/latest)

> The download link will work after the first APK is published through GitHub Releases.

PhaseSync demonstrates a software interface for monitoring renewable-energy generation, grid usage, battery conditions and connected electrical loads.

> **Status:** Functional UI prototype using simulated data. It is not connected to real electrical hardware, a backend server or a production database.

## SIH 2025 Problem Statement

* **Problem Statement ID:** SIH25064
* **Title:** Improving the Renewable Energy Hosting Capacity in Distribution Feeders and Improving the Power Quality of the Distribution Network During High RE Injection
* **Organization:** Government of Kerala
* **Department:** Kerala State Electricity Board Limited (KSEBL)
* **Category:** Hardware
* **Theme:** Renewable / Sustainable Energy

## Software Concept

The PhaseSync application demonstrates how users or operators could:

* Monitor simulated solar, grid and battery information
* View energy-flow information through a dashboard
* Analyse historical energy trends
* View system alerts
* Control conceptual connected loads
* Configure battery thresholds
* Switch between light and dark themes

## Current Status

| Component                    | Status                      |
| ---------------------------- | --------------------------- |
| Mobile UI and navigation     | Implemented                 |
| Energy dashboard             | Simulated                   |
| Analytics charts             | Simulated                   |
| Load controls                | UI and in-memory simulation |
| Alerts                       | Simulated in-app alerts     |
| Theme switching              | Working                     |
| Backend and database         | Not implemented             |
| Physical hardware connection | Not implemented             |
| Automatic phase balancing    | Not implemented             |

## Technology Stack

* Flutter
* Dart
* Provider
* FL Chart
* Material Design
* Google Fonts

## Team

Developed collaboratively by:

* **[Me](https://github.com/rahulsingha24)**
* **[Sukriti Bera](https://github.com/SukritiBera108)**

Together, we worked on the application requirements, feature planning, mobile workflow, UI/UX direction, prototype implementation, testing and iterative refinement.

The application was created through an AI-assisted prototyping workflow based on our requirements, interface direction, testing feedback and corrections.

## Run Locally

### Requirements

* Flutter SDK
* Android Studio or Visual Studio Code
* Android emulator or physical Android device

### Installation

```bash
git clone https://github.com/rahulsingha24/PhaseSync-SIH25064-Prototype.git
cd PhaseSync-SIH25064-Prototype
flutter pub get
flutter run
```

### Build APK

```bash
flutter build apk --release
```

The generated APK will normally be available at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Limitations

* All energy readings are simulated.
* Data is not stored permanently.
* Controls do not operate real electrical equipment.
* No ESP32 or other controller is connected.
* No MQTT, Bluetooth, WebSocket or REST hardware communication is implemented.
* The application is not production-ready.

## Future Improvements

* Connect the application to a real IoT controller
* Add live hardware-data communication
* Implement persistent database storage
* Add user authentication
* Develop automatic phase-balancing logic
* Add real push notifications

## Disclaimer

PhaseSync is an educational hackathon prototype. It must not be used to operate real electrical systems without proper hardware protection, professional electrical design, security testing and regulatory validation.