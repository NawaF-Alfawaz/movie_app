# Movie App (Frontend - Flutter)

This project is a Flutter-based mobile application designed to display a list of movies, allowing users to book movie slots by communicating with a backend server. The backend manages movie listings, available time slots, and reservation capacity. The Flutter frontend handles user interaction, such as listing movies, checking availability, and processing reservations.

## Getting Started

This guide will help you set up and run the Movie App Flutter project.

### Prerequisites

Before starting, make sure you have the following installed:

1. [Flutter SDK](https://flutter.dev/docs/get-started/install)
2. [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter and Dart plugins
3. A mobile device (physical or emulator) for testing

### Installation

1. **Clone the Repository**
   
   Clone the Flutter project from GitHub:
   ```sh
   git clone https://github.com/NawaF-Alfawaz/movie_app.git
   cd movie_app
   ```

2. **Install Dependencies**
   
   Run the following command to install all the required Flutter dependencies:
   ```sh
   flutter pub get
   ```

3. **Ensure Backend is Running**
   
   This Flutter project relies on a backend server to fetch movie data and handle bookings. You need to set up and run the backend project first.
   
   - Clone and run the backend repository from [Movie Backend](https://github.com/NawaF-Alfawaz/movie_backend).
   - Follow the backend setup instructions to start the server (usually using Node.js).

4. **Update Backend URL**
   
   Once the backend is up and running, you need to update the backend URL in the Flutter project to ensure it points to the correct IP address and port.
   
   - Open the file `lib/config.dart`.
   - Locate the following line:
     ```dart
     String baseUrl = "http://10.0.2.2:3000";
     ```
   - Update `baseUrl` to point to your backend server. If you are running the backend locally and testing on an Android emulator, `10.0.2.2` typically maps to `localhost`. If you are using a physical device, replace it with your computer's IP address.

5. **Run the Flutter Project**
   
   To start the Flutter application, connect your emulator or device and run:
   ```sh
   flutter run
   ```

## Features

### 1. Movie Listing Page
   - Displays a list of movies retrieved from the backend server.
   - Each movie card shows the title and the available time slots with their capacities.
   - Users can select a movie and choose a specific time slot to proceed with the booking.

### 2. Availability Check
   - After selecting a movie and a time slot, the app checks the remaining capacity by calling the backend API.
   - Displays the remaining number of seats for the selected time slot.

### 3. Reservation Page
   - Users can input the number of seats they want to reserve after verifying availability.
   - Submits a reservation request to the backend server.
   - Displays a confirmation message for successful bookings or an error message in case of issues (e.g., insufficient seats).

## Notes

- Make sure that the backend server is running before launching the Flutter app. The app will not be able to fetch movie data or make reservations without the backend.
- If you encounter issues with connectivity, verify that the `baseUrl` in `lib/config.dart` points to the correct backend URL, based on your environment setup.

## Useful Commands

- **Fetch Dependencies**: `flutter pub get`
- **Run Application**: `flutter run`
- **Check for Issues**: `flutter doctor`

---

If you have any questions or run into issues, feel free to raise them in the GitHub repository or contact the maintainer.

