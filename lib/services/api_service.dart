import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String tmdbApiKey = '1756a7299183c8af0926ce2cd0491430';

  Future<List<dynamic>> getTrendingMovies() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/trending/movie/week?api_key=$tmdbApiKey'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<dynamic>> fetchMovies() async {
    final url =
        'https://api.themoviedb.org/3/trending/movie/week?api_key=$tmdbApiKey&language=en-US';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<List<dynamic>> queryMovies(String query) async {
    final encodedQuery = Uri.encodeComponent(query);

    final url = 'https://api.themoviedb.org/3/search/movie?api_key=$tmdbApiKey&language=en-US&page=1&include_adult=false&query=$encodedQuery';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  // ==== Local API
  Future<String> register(String email, String password, String name, File? avatar) async {
    final response = await http.post(
      Uri.parse(''),
      body: { 'email': email, 'password': password, 'name': name },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final email = data['email'];

      const storage = FlutterSecureStorage();
      await storage.write(key: 'USER_EMAIL', value: email);
      await storage.write(key: 'USER_TOKEN', value: token);

      return token;
    } else {
      throw Exception('Falha ao cadastrar');
    }
  }
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://172.25.53.235:3000/api/v1/users/sign_in'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final email = data['email'];

      const storage = FlutterSecureStorage();
      await storage.write(key: 'USER_EMAIL', value: email);
      await storage.write(key: 'USER_TOKEN', value: token);

      return token;
    } else {
      throw Exception('Falha ao logar');
    }
  }

  Future<void> logout() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }

  Future<String> addToWatchlist(int movieID) async {
    try {
      const storage = FlutterSecureStorage();
      final readEmail = await storage.read(key: 'USER_EMAIL') ?? '';
      final readToken = await storage.read(key: 'USER_TOKEN') ?? '';

      final Map<String, String> tokenData = {
        'USER_EMAIL': readEmail,
        'USER_TOKEN': readToken
      };

      final response = await http.post(
        Uri.parse('http://172.25.53.235:3000/api/v1/users/me/movies/'),
        headers: tokenData,
        body: {'imdb_id': movieID.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      }

      return '';
    } catch (e) {
      throw Exception('Falha ao adicionar a lista');
    }
  }


  Future<String> removeFromWatchlist(int movieID) async {
    try {
      const storage = FlutterSecureStorage();
      final readEmail = await storage.read(key: 'USER_EMAIL') ?? '';
      final readToken = await storage.read(key: 'USER_TOKEN') ?? '';

      final Map<String, String> tokenData = {
        'USER_EMAIL': readEmail,
        'USER_TOKEN': readToken
      };

      final response = await http.delete(
        Uri.parse('http://172.25.53.235:3000/api/v1/users/me/movies/$movieID'),
        headers: tokenData,
      );

      if (response.statusCode == 200) {
        return 'Deletado';
      }

      return '';
    } catch (e) {
      throw Exception('Falha ao adicionar a lista');
    }
  }

  Future<bool> fetchUserMovie(int movieID) async {
    try {
      const storage = FlutterSecureStorage();
      final readEmail = await storage.read(key: 'USER_EMAIL') ?? '';
      final readToken = await storage.read(key: 'USER_TOKEN') ?? '';

      final Map<String, String> tokenData = {
        'USER_EMAIL': readEmail,
        'USER_TOKEN': readToken
      };

      final response = await http.get(
        Uri.parse('http://172.25.53.235:3000/api/v1/users/me/movies/$movieID'),
        headers: tokenData,
      );

      final data = jsonDecode(response.body);

      return data != null;
    } catch (e) {
      throw Exception('Falha ao adicionar a lista');
    }
  }

  Future<bool> fetchUserMovieWatched(int movieID) async {
    try {
      const storage = FlutterSecureStorage();
      final readEmail = await storage.read(key: 'USER_EMAIL') ?? '';
      final readToken = await storage.read(key: 'USER_TOKEN') ?? '';

      final Map<String, String> tokenData = {
        'USER_EMAIL': readEmail,
        'USER_TOKEN': readToken
      };

      final response = await http.get(
        Uri.parse('http://172.25.53.235:3000/api/v1/users/me/movies/$movieID/watched'),
        headers: tokenData,
      );

      final data = jsonDecode(response.body);

      return data;
    } catch (e) {
      throw Exception('Falha ao adicionar a lista');
    }
  }

  Future<void> toggleWatched(int movieID) async {
    const storage = FlutterSecureStorage();
    final readEmail = await storage.read(key: 'USER_EMAIL') ?? '';
    final readToken = await storage.read(key: 'USER_TOKEN') ?? '';

    final Map<String, String> tokenData = {
        'USER_EMAIL': readEmail,
        'USER_TOKEN': readToken
      };

    await http.put(
      Uri.parse('http://172.25.53.235:3000/api/v1/users/me/movies/$movieID/toggle_watched'),
      headers: tokenData,
    );
  }
}
