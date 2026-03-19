# Dota 2 Draft Plan Mobile

A Flutter application for planning Dota 2 drafts, including hero bans, picks, threats, and item timings.

## Local Setup (5 Steps)

1.  **Prerequisites**: Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured on your machine.
2.  **Fetch Dependencies**: Open your terminal in the project root and run:
    ```bash
    flutter pub get
    ```
3.  **Configure Backend**: The app connects to a Laravel backend. Ensure your backend is running.
4.  **Set API URL**: If your local backend IP differs from the default (`192.168.0.119`), use the `BASE_URL` define:
    ```bash
    # Example
    --dart-define=BASE_URL=http://localhost:8000/api
    ```
5.  **Run Application**: Launch the app on your connected device or emulator:
    ```bash
    flutter run --dart-define=BASE_URL=http://<YOUR_IP>:8000/api
    ```
