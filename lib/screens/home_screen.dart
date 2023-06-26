// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final apiService = ApiService();

  TextEditingController searchController = TextEditingController();
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final moviesData = await apiService.fetchMovies();
      setState(() {
        movies = moviesData;
      });
    } catch (e) {
      // Tratar o erro de requisição
    }
  }

  Future<void> queryMovies(String query) async {
    try {
      final moviesData = await apiService.queryMovies(query);
      setState(() {
        movies = moviesData;
      });
    } catch (e) {
      // Tratar o erro de requisição
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          GestureDetector(
            onTap: () {
              apiService.logout();
              Navigator.pushNamed(context, '/');
            },
            child: const Icon(Icons.exit_to_app)
          ),
        ]
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                queryMovies(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                    width: 50,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie['title']),
                  subtitle: Text(movie['overview']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsScreen(
                          id: movie['id'],
                          title: movie['title'],
                          overview: movie['overview'],
                          banner: 'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}',
                          releaseYear: DateTime.parse(movie['release_date']).year,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
