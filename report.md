# Expense Tracker App: Report

This document outlines the design decisions, architectural choices, and testing approach used in the development of the **Expense Tracker App**.


## Design Decisions

### 1. **User-Centric UI**
   - The app was designed with the user in mind, focusing on simplicity and ease of use.
   - The UI provides clear options for adding, editing, and deleting expenses with intuitive interaction patterns.

### 2. **Drawer Navigation**
   - A **drawer navigation** is used to provide quick access to the main sections of the app, such as adding an expense, viewing the expenses list, and settings.
   - This choice was made to maintain a clean interface while providing easy navigation.

### 3. **FAB (Floating Action Button) for Quick Add**
   - A **Floating Action Button (FAB)** is provided for adding new expenses quickly, as it's a common and expected interaction in modern apps.
   - The FAB is always accessible and visible for ease of use.

### 4. **Card-Based Expense Display**
   - Expenses are displayed in **cards**, which provide a visually appealing way to present the data.
   - Each card includes details such as the description, amount, and date, making it easy to read and understand at a glance.



## Architectural Choices

### 1. **State Management: Provider**
   - **Provider** was chosen for state management because it's simple, scalable, and well-integrated with Flutter.
   - The app uses Provider to manage and update the list of expenses across different screens, ensuring a reactive and smooth user experience.

### 2. **Data Persistence: Hive**
   - **Hive** was chosen for local data storage due to its speed, simplicity, and ease of use.
   - Expenses are saved locally using Hive, which makes the app usable even without an internet connection.

### 3. **Separation of Concerns**
   - The app follows the **separation of concerns** principle by dividing the app into different layers:
     - **UI** (widgets)
     - **State management** (Provider)
     - **Data models** (ExpenseModel)
     - **Persistence** (Hive)

   This structure promotes maintainability, readability, and ease of testing.

### 4. **Localization: l10n**
   - The app supports multiple languages using Flutter's **l10n** (localization) package.
   - This decision ensures that users from different regions can interact with the app in their preferred language.


## Testing Approach

### 1. **Unit Testing**
   - **Unit testing** is performed to validate individual functions or methods, such as validation logic for input fields.
   - Unit tests are run using the Flutter testing framework to ensure that the core logic of the app is functioning correctly.

### 4. **Manual Testing**
   - **Manual testing** is done by running the app on real devices or emulators to check for usability issues, UI bugs, or any behavior that may be missed during automated testing.
   - It helps in identifying issues that might not be covered by automated tests, like edge cases in UI interactions.


## Conclusion

The **Expense Tracker App** was designed with a focus on usability, maintainability, and performance. We chose a **user-centric UI**, **Provider** for state management, and **Hive** for local data persistence to ensure that the app is simple to use, efficient, and performs well even offline. The app is tested thoroughly with **unit, widget, and integration tests**, ensuring that both the business logic and UI function as expected.


## Future Improvements

- **Cloud Sync**: Adding the ability to sync expenses across devices using a cloud-based service.
- **User Authentication**: Implementing user accounts for personalized expense tracking.
- **Expense Categories**: Introducing categories for better expense classification and reporting.

