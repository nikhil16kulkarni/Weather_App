# Weather App

[![Flutter](https://img.shields.io/badge/Flutter-3.19.6-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-2.19.6-blue.svg)](https://dart.dev)

## Overview

The Weather App is a Flutter-based application that provides weather information for various locations. It utilizes the OpenWeather One Call API to fetch current weather conditions, 5-day weather forecasts, and detailed wind speed information. The app supports fetching weather data based on the user's current location and allows users to search for weather information by entering city names.

## Features

- **Current Weather Data:** Displays the current temperature, weather description, wind speed, and other relevant weather parameters.
- **5-Day Weather Forecast:** Provides a forecast for the next 5 days, including daily temperature highs and lows.
- **Wind Speed Information:** Detailed wind speed and direction data for the current weather and forecast.
- **Location-Based Weather:** Automatically fetches weather data based on the user's current location using the device's GPS.
- **City Search:** Allows users to search for weather information by entering city names, with auto-complete suggestions for city names.
- **Responsive Design:** Optimized for both mobile and web platforms, ensuring a smooth user experience across different devices.

## How It Works

### 1. Fetching Current Location

The app uses the `geolocator` package to fetch the user's current location. When the app starts, it requests permission to access the device's location. Once granted, it retrieves the latitude and longitude coordinates of the user's current location.

### 2. Fetching Weather Data

The app utilizes the OpenWeather One Call API to fetch weather data. The API requires latitude and longitude coordinates to provide accurate weather information. The following weather data is fetched:

- **Current Weather:** Includes temperature, weather description, wind speed, humidity, and more.
- **5-Day Forecast:** Provides daily forecasts with temperatures, weather conditions, and wind speed.
- **Wind Information:** Detailed wind speed and direction data.

### 3. City Search and Auto-Complete

The app provides a search bar where users can enter city names to fetch weather data for specific locations. As the user types, the app uses the OpenWeather Geocoding API to fetch and display auto-complete suggestions for city names. This helps users find and select the correct city quickly.

### 4. Displaying Weather Data

The app displays weather data in a user-friendly format. Key weather parameters are shown prominently, and users can view detailed information for the current weather and the 5-day forecast. The UI is designed to be intuitive and easy to navigate.

## Getting Started

### Prerequisites

- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter SDK
- OpenWeather API Key: Sign up for an API key at [OpenWeather](https://openweathermap.org/api)

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/nikhil16kulkarni/Weather_App.git
   cd Weather_App
   ```
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the App:**
    ```bash
    flutter run
    ```

### Configuration
The app requires an API key from OpenWeather. You need to add your API key in the appropriate place in the code. Replace YOUR_API_KEY with your actual OpenWeather API key.

### Dependencies
**http:** For making API requests to OpenWeather. </br>
**geolocator:** For fetching the user's current location.</br>
**flutter/material.dart:** Flutter's core package for building UIs.</br>
