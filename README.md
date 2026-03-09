# Gym & Calorie Tracker (Local iOS Utility)

A high-performance, privacy-centric native iOS application designed to track physical training volume and nutritional intake exclusively on-device.

## Overview

This project was built to address a stark flaw in modern fitness tracking applications: mandatory cloud synchronization and data harvesting. This tracker guarantees absolute privacy by enforcing a strictly offline data model.

Every set, rep, calorie, and physiological synchronization remains locally encrypted within the application's sandbox on iOS. 

## Core Architecture

- **UI Framework:** SwiftUI 
- **Persistence Layer:** SwiftData (Local SQLite)
- **Data Visualizations:** Swift Charts
- **System Integrations:** Apple HealthKit (Read-Only)

## Features

### 🏋️ Workout Tracking (Tree Structure)
Navigate your training history by day. Add custom exercises directly, and the app will persistently catalog them for auto-completion. Each exercise contains nested instances of `ExerciseSet`, allowing you to record specific weight and repetition volumes per set rather than simple flat numbers.

### 🍽️ Nutrition & Meal Tracking 
A dedicated UI flow allowing you to log explicit meals (e.g., "Overnight Oats", "Post-Workout Shake"). It visually isolates daily protein consumption against a defined goal and sums all macronutrients (Carbohydrates, Fats) and total calories.

### 📊 Offline Correlation Engine 
Utilizing Apple HealthKit, the application asynchronously fetches your trailing 7-day **Active Energy Burned**, **Basal Metabolic Rate (BMR)**, and **Step Count**. It renders this data natively via Swift Charts, laying your Caloric Intake directly against your Total Energy Expenditure to instantly visualize your daily surplus or deficit vectors.

### 🔌 Intelligent Fallbacks
Designed to work even if the user explicitly revokes HealthKit permissions. The Integration panel gracefully renders manual input steppers, injecting off-grid approximations straight into the central SwiftData analytics pipeline.

## Getting Started

Because this application relies entirely on local device frameworks, no API keys, accounts, or Firebase configurations are required.

1. Open `GymCalorieTracker.xcodeproj` in Xcode 15+.
2. Ensure your active scheme target is an iOS Simulator or connected iOS Device.
3. Select the Project File -> Targets -> Signing & Capabilities.
4. Set your custom Apple Team and Bundle Identifier.
5. Build and Run (`Cmd + R`).

**Note on Permissions:** Upon initial execution, the application will prompt for Health Access. If testing via Simulator, ensure you have populated the Health app inside the simulator with mock data (Steps and Energy), or leverage the manual fallback sliders under the `Integration` tab.