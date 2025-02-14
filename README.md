# 📝 Notes Ledger (Spring Boot + Flutter)

A **Notes Ledger** application with a **Spring Boot** backend and **Flutter** frontend. This app allows users to securely create, update, and manage notes using JWT authentication.

---

## 🚀 Features

### ✅ Backend (Spring Boot)
- **User Authentication** (JWT & Basic Auth)
- **Spring Security for Secure API Access**
- **CRUD Operations for Notes**
- **MongoDB for Data Storage**

### 🎨 Frontend (Flutter)
- **Modern UI with Google Fonts & Staggered Grid View**
- **Supabase Storage for MP3 file uploads**
- **Audio Playback with `just_audio`**
- **State Management using Riverpod**

---

## 🛠️ Tech Stack

### Backend (Spring Boot)
- **Spring Boot 3**
- **Spring Security (JWT Authentication)**
- **Spring Data MongoDB**
- **Hibernate & JPA**
- **Maven for Dependency Management**

### Frontend (Flutter)
- **Dart & Flutter SDK**
- **Riverpod for State Management**
- **Networking: HTTP package**
- **UI Components:**
  - Staggered Grid View
  - Google Fonts
  - Cupertino Icons
  - Font Awesome Icons
- **UUID Generator for Unique IDs**

---

## 📌 Setup Instructions

### Backend (Spring Boot)
#### Prerequisites
- **Java 17+**
- **Maven**
- **MongoDB Database**

#### Steps to Run
1. Clone the repository:
   ```sh
   git clone https://github.com/ShallowAwe/notes_ledger.git
   cd notes_ledger/backend
   ```
2. Update `application.properties` with your MongoDB credentials.
3. Build and run the project:
   ```sh
   mvn clean install
   mvn spring-boot:run
   ```
4. The backend will be available at `http://localhost:8080`.

### Frontend (Flutter)
#### Prerequisites
- **Flutter SDK Installed**
- **Dart Installed**

#### Steps to Run
1. Navigate to the Flutter directory:
   ```sh
   cd notes_ledger/frontend
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

---

## 🛡️ API Endpoints

### Authentication
| Method | Endpoint            | Description          |
|--------|--------------------|----------------------|
| `POST` | `/auth/login_jwt`  | User login (JWT)     |
| `POST` | `/auth/signup`     | User registration    |

### Notes Management
| Method   | Endpoint       | Description              |
|----------|---------------|--------------------------|
| `GET`    | `/notes/`      | Fetch all notes          |
| `POST`   | `/notes/`      | Create a new note        |
| `PUT`    | `/notes/{username}`  | Update a note            |
| `DELETE` | `/notes/{username}`  | Delete a note            |

---

## 🎯 Future Enhancements
- 🔹 Implement **Firebase Authentication**
- 🔹 Add **Offline Mode**
- 🔹 UI Enhancements & Dark Mode
- 🔹 Implement Note Sharing Feature

---

## 🤝 Contributing

Contributions are welcome! Feel free to fork the repository and submit a pull request.

---

## 📜 License

This project is licensed under the MIT License.

🔗 **Follow me on GitHub** → [ShallowAwe](https://github.com/ShallowAwe)

