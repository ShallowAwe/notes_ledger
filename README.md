# 📝 Notes Ledger (Spring Boot + Flutter)

This project is a **Notes Ledger** built using **Spring Boot** for the backend and **Flutter** for the frontend. The app allows users to create, update, delete, and manage their notes securely with JWT authentication.

## 🚀 Features
- **User Authentication** (Basic Auth & JWT)
- **Secure API with Spring Security**
- **CRUD Operations for Notes**
- **Flutter UI with Supabase Storage for MP3 files**
- **Audio Playback using `just_audio` package**

## 🛠️ Tech Stack
### Backend (Spring Boot)
- **Spring Boot 3**
- **Spring Security (JWT Auth)**
- **Spring Data MongoDB**
- **Hibernate**
- **Maven**

### Frontend (Flutter)
- **Flutter (Dart)**
- **Supabase Storage** (for MP3 files)
- **just_audio** (for audio playback)
- **Provider / Riverpod (State Management)**

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
- **Flutter SDK**
- **Dart**

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
| `PUT`    | `/notes/{id}`  | Update a note            |
| `DELETE` | `/notes/{id}`  | Delete a note            |

---

## 🎯 Future Enhancements
- 🔹 Add **Firebase Auth** for login
- 🔹 Implement **Dark Mode**
- 🔹 Improve UI/UX with animations
- 🔹 Add **Offline Mode**

## 🤝 Contributing
Contributions are welcome! Feel free to fork the repository and submit a pull request.

## 📜 License
This project is licensed under the MIT License.

---

🔗 **Follow me on GitHub** → [ShallowAwe](https://github.com/ShallowAwe)

