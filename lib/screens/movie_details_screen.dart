import 'package:flutter/material.dart';
import 'package:my_film_list_flutter/services/api_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();

  final String title;
  final String banner;
  final String overview;
  final int releaseYear;
  final int id;

  const MovieDetailsScreen({
    super.key,
    required this.title,
    required this.banner,
    required this.overview,
    required this.releaseYear,
    required this.id,
  });
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final apiService = ApiService();
  bool hasUserMovie = false;
  bool isUserMovieWatched = false;

  @override
  void initState() {
    super.initState();
    checkUserMovieExists();
  }

  Future<void> checkUserMovieExists() async {
    final response = await apiService.fetchUserMovie(widget.id);
    final responseWatched = await apiService.fetchUserMovieWatched(widget.id);
    setState(() {
      hasUserMovie = response;
      isUserMovieWatched = responseWatched;
    });
  }

  Future<void> addToWatchlist(int tmdbID) async {
    try {
      await apiService.addToWatchlist(tmdbID);

      setState(() {
        checkUserMovieExists();
      });
    } catch (e) {
      // Tratar o erro de requisição
    }
  }

  Future<void> removeFromWatchlist(int tmdbID) async {
    try {
      await apiService.removeFromWatchlist(tmdbID);

      setState(() {
        checkUserMovieExists();
      });
    } catch (e) {
      // Tratar o erro de requisição
    }
  }

  void toggleWatched(int tmdbID) async {
    try {
      await apiService.toggleWatched(tmdbID);

      setState(() {
        checkUserMovieExists();
      });
    } catch (e) {
      // Tratar o erro de requisição
    }
  }

  Widget isOnList() {
    if(hasUserMovie) {
      return ElevatedButton(
        onPressed: () {
          removeFromWatchlist(widget.id);
        },
        child: const Text('Remover da lista'),
      );
    }

    return ElevatedButton(
      onPressed: () {
        addToWatchlist(widget.id);
      },
      child: const Text('Adicionar a lista'),
    );
  }

  Widget isWatched() {
    if(!hasUserMovie) {
      return const SizedBox.shrink();
    }

    if(isUserMovieWatched) {
      return ElevatedButton(
        onPressed: () {
          toggleWatched(widget.id);
        },
        child: const Text('Marcar como não assistido'),
      );
    }

    return ElevatedButton(
      onPressed: () {
        toggleWatched(widget.id);
      },
      child: const Text('Marcar como assistido'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(widget.banner),
          const SizedBox(height: 16),
          Text(widget.overview),
          Text('Ano de lançamento: ${widget.releaseYear}'),
          isOnList(),
          isWatched(),
        ],
      ),
    );
  }
}

