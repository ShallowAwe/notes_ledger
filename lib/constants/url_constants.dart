class ApiUrls {
  static const String baseUrl = "http://localhost:8080";

  // Authentication Endpoints
  static const String login = "$baseUrl/public/login_jwt";
  static const String signup = "$baseUrl/public/register";

  // Notes Endpoints
  static const String getNotes = "$baseUrl/notes/";
  static const String createNote = "$baseUrl/notes/";
  static const String updateNote = "$baseUrl/notes/{id}";
  static const String deleteNote = "$baseUrl/notes/{id}";

  //user Endpoints
}
