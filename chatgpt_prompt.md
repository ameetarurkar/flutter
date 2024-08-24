I want to build a note-taking app in Flutter. What instructions do I need to give my AI coding app?

Creating a note-taking app in Flutter is a great project! To guide your AI coding app effectively, you can break down the project into specific instructions. Here’s a step-by-step outline you can use:

### 1. **Project Setup**

- **Create a New Flutter Project:**
  - Command: `flutter create note_taking_app`
  - Change directory: `cd note_taking_app`

### 2. **Define App Structure**

- **Create Basic Folders:**
  - `lib/` - for Dart code
  - `lib/screens/` - for different screens of the app
  - `lib/widgets/` - for reusable widgets
  - `lib/models/` - for data models
  - `lib/utils/` - for utility functions

### 3. **UI Design**

- **Main Screen:**
  - Design a home screen that displays a list of notes.
  - Provide a floating action button (FAB) to add a new note.
- **Add/Edit Note Screen:**
  - Create a screen with a text field for note title and a larger text area for note content.
  - Include save and cancel buttons.

### 4. **State Management**

- **Choose State Management Solution:**
  - You can use `Provider`, `Riverpod`, `Bloc`, or `setState` for managing state. Example: `Provider` for simplicity.

### 5. **Data Persistence**

- **Local Storage:**
  - Use `sqflite` or `hive` for local database storage.
  - Define a `Note` model class.
  - Implement CRUD operations (Create, Read, Update, Delete).

### 6. **Implement Features**

- **Home Screen:**

  - Display notes in a list view.
  - On tap, navigate to the Add/Edit Note screen.

- **Add/Edit Note Screen:**
  - Provide options to save or discard changes.
  - Validate input (e.g., check if title is not empty).

### 7. **Database Integration**

- **Setup Local Database:**
  - Define database schema and initialize the database.
  - Implement methods to save, retrieve, update, and delete notes.

### 8. **Routing and Navigation**

- **Setup Routing:**
  - Define routes in `MaterialApp` for different screens.
  - Implement navigation between screens.

### 9. **Error Handling and Validation**

- **Add Error Handling:**
  - Handle possible errors in database operations and user input.
- **Input Validation:**
  - Validate that the title is not empty and handle other validation requirements.

### 10. **Testing**

- **Write Unit Tests:**
  - Test individual components, such as models and database operations.
- **Write Widget Tests:**
  - Test UI components and interactions, such as form submissions and navigation.

### 11. **Styling and UI Enhancements**

- **Apply Themes:**
  - Use Flutter’s theming to ensure a consistent look and feel.
- **Enhance UI:**
  - Improve user experience with animations, icons, and intuitive layouts.

### 12. **Deployment**

- **Build and Release:**
  - Follow Flutter’s guidelines to build the app for Android and iOS.
  - Configure app icons, splash screens, and app permissions.

### Example Instructions to AI Coding App:

1. **Create a new Flutter project named `note_taking_app`.**
2. **Define the folder structure: `lib/screens/`, `lib/widgets/`, `lib/models/`, and `lib/utils/`.**
3. **Design a Home Screen with a list of notes and a FAB to add a new note.**
4. **Create an Add/Edit Note screen with a text field for the title and a larger text area for the content.**
5. **Implement state management using `Provider`.**
6. **Set up local storage using `sqflite`. Define the `Note` model and implement CRUD operations.**
7. **Configure routing to navigate between the Home Screen and Add/Edit Note screen.**
8. **Add error handling and input validation to ensure a smooth user experience.**
9. **Write unit and widget tests to ensure functionality and UI correctness.**
10. **Apply styling and themes to enhance the app’s appearance.**
11. **Build and release the app for Android and iOS, including app icons and splash screens.**

By providing these clear and structured instructions, your AI coding app will be well-guided in building your note-taking app in Flutter.
