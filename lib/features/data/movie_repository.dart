import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieRepository {
  final String baseUrl;

  // Constructor to initialize the base URL
  MovieRepository({required this.baseUrl});

  // Method to get a list of all movies
  Future<List<Movie>> listMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movies'));

    if (response.statusCode == 200) {
      try {
        // Decode the JSON response as a List of dynamic
        final List<dynamic> moviesJson =
            json.decode(response.body) as List<dynamic>;
        print(moviesJson);

        // Map each element of the list to a Movie object
        return moviesJson.map((movieJson) {
          return Movie.fromJson(movieJson as Map<String, dynamic>);
        }).toList();
      } catch (e) {
        throw Exception('Failed to parse movies: $e');
      }
    } else {
      throw Exception(
          'Failed to load movies. Status code: ${response.statusCode}');
    }
  }

  // Method to check availability of a specific time slot for a movie
  Future<int> checkAvailability(String movieId, int timeSlotId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/movies/$movieId/timeslots/$timeSlotId/availability'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> availabilityJson = json.decode(response.body);
      return availabilityJson['remainingCapacity'] as int;
    } else if (response.statusCode == 404) {
      throw Exception('Movie or time slot not found');
    } else {
      throw Exception('Failed to check availability');
    }
  }

  // Method to update booked count for a specific time slot
  Future<void> updateBookedCount(
      String movieId, int timeSlotId, int numberOfPeople) async {
    final response = await http.put(
      Uri.parse('$baseUrl/reservations/$movieId/timeslots/$timeSlotId/book'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'numberOfPeople': numberOfPeople}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update booked count');
    }
  }
}
