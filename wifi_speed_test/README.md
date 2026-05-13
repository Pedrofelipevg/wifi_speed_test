# Wi-Fi Speed Test

Welcome to the **Wi-Fi Speed Test** app! This is a beautiful, modern, and intuitive Flutter application designed to measure your internet connection's speed and latency. 

## Description
The Wi-Fi Speed Test app is a mobile application built to give you real-time insights into your network's performance. By providing accurate metrics for **Ping**, **Download speed**, and **Upload speed**, this app helps you understand the true capabilities of your internet connection. It features an interactive, dynamic speedometer and a clean interface that makes network testing a breeze.

## Problem Statement
Have you ever wondered if your internet provider is actually delivering the speeds you pay for? Lack of transparency in internet speeds is a common issue. This app solves that problem by giving users an accessible, fast, and reliable tool to test their Wi-Fi and mobile data connections directly from their smartphones.

## Target Audience
This app is built for **everyone**!
- **Casual Users**: People who want a quick, easy-to-understand check of their internet connection without navigating complex technical menus.
- **Technology Students**: Students looking for a solid example of a Flutter application utilizing modern architectural patterns (like MVVM) and robust state management.

## Technologies
To bring this app to life, we used some of the best tools in the Flutter ecosystem:
- **Flutter & Dart**: The core framework and language for building natively compiled applications.
- **Provider**: For efficient and scalable state management.
- **shared_preferences**: To locally save your test history and Terms of Use acceptance.
- **flutter_speed_test_plus**: The engine that measures actual download and upload transfer rates.
- **syncfusion_flutter_gauges**: To draw the beautiful, interactive speedometer on the home screen.
- **connectivity_plus**: To seamlessly check whether the device is online or offline.
- **flutter_launcher_icons**: For automating the generation of the application's launcher icons.
- **http**: For manual ping requests and network communication.

## Architecture
This project proudly adopts the **MVVM (Model-View-ViewModel)** architecture. This makes the code highly organized, easy to read, and simple to maintain:
- **Models**: The data structures (like our `TestResult` class) that hold the information.
- **ViewModels**: The brains of the operation. They handle the logic, communicate with services, and notify the UI of any changes (like updating the needle on the speedometer).
- **Views**: The UI components. They are strictly "dumb" and only listen to the ViewModels to know what to display on the screen.

## Features
- **Real-time Speed Measurement**: Watch the needle move as the app tests your Ping, Download, and Upload speeds.
- **Local History**: All your past tests are saved locally on your device, allowing you to track your network's performance over time.
- **Connection Awareness**: If your internet drops, the app immediately knows and handles the error gracefully.
- **Color-Coded Feedback**: Easily identify if your speed is good (Green), average (Amber), or poor (Red).

## API Details
While this app doesn't rely on a custom backend, it connects to real-world infrastructure to get accurate results:
- **Ping**: The app measures latency by sending a quick HTTP request to public servers (like Google).
- **Speed Testing**: Under the hood, the `flutter_speed_test_plus` package establishes sockets and downloads/uploads dummy data payloads to dedicated speed test servers (like Ookla or equivalent hubs) to calculate true transfer rates.

## State Management
We use the **Provider** package alongside Flutter's built-in `ChangeNotifier`. 
This allows our Views to "listen" to our ViewModels. When a test is running and the download speed changes, the `SpeedTestViewModel` calls `notifyListeners()`. The UI, wrapped in a `Consumer` widget, hears this call and instantly redraws the speedometer to reflect the new data. This happens dozens of times a second for a buttery smooth animation, all without messy global variables!

## AI Utilization
This project was developed with the assistance of **Antigravity AI**. The AI acted as a powerful pair-programming partner, helping to:
- Structure the initial MVVM architecture.
- Write clean, maintainable Dart code and implement Provider.
- Troubleshoot Android build errors and configure permissions.
- Generate high-quality documentation (like this README) and UI assets.

*(Note: AI was used to accelerate development, but all logic and final implementations were reviewed and verified by the human developer).*

## Execution Instructions
Want to run the code yourself? Follow these simple steps:

1. **Prerequisites**: Make sure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
2. **Clone/Download**: Get a copy of this repository on your machine.
3. **Install Dependencies**: Open a terminal in the project folder and run:
   ```bash
   flutter pub get
   ```
4. **Analyze Code (Optional)**: Check for any linting errors:
   ```bash
   flutter analyze
   ```
5. **Run the App**: Connect your smartphone or start an emulator, then run:
   ```bash
   flutter run
   ```

## Screenshots
*(Add your screenshots here!)*
- `[ Home Screen ]`
- `[ Testing in Progress ]`
- `[ History Screen ]`

## Author
**Developed by:** Programming II Student
*Designed for learning, built for performance.*
