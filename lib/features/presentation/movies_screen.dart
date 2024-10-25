import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../data/movie_repository.dart';
import '../models/movie.dart';
import 'reservation_screen.dart';
import 'widgets/movie_card.dart';
import 'widgets/roundedButton.dart';

// The main MoviesScreen widget which displays available movies for reservation
class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  // Track the index of the current movie in the carousel
  int _current = 0;
  // Track the selected movie index for reservations
  int movieIndex = 0;
  // Track the currently selected time slot for a movie
  TimeSlot? _selectedTimeSlot;
  // List of movies that will be fetched from the repository
  List<Movie> _movies = [];
  // Movie repository instance to manage API calls
  final MovieRepository _movieRepository = MovieRepository(baseUrl: baseUrl);

  @override
  void initState() {
    super.initState();
    _fetchMovies(); // Fetch the movies when the widget is initialized
  }

  // Fetch the list of movies from the repository asynchronously
  Future<void> _fetchMovies() async {
    try {
      print("_fetchMovies");
      final movies = await _movieRepository.listMovies();
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      // Handle errors by showing a Snackbar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load movies: $e')),
      );
    }
  }

  // Method to select a time slot for reservation
  Future<void> selecTimeSlot() async {
    if (_selectedTimeSlot != null) {
      final movie = _movies[movieIndex];
      try {
        // Find the index of the selected time slot
        final timeSlotIndex = movie.timeSlots.indexOf(_selectedTimeSlot!);
        // Check the remaining capacity for the selected time slot
        final remainingCapacity =
            await _movieRepository.checkAvailability(movie.id, timeSlotIndex);
        // If seats are available, navigate to the reservation screen
        if (remainingCapacity > 0) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReservationScreen(
                      movieId: movie.id,
                      timeSlot: _selectedTimeSlot!,
                      timeSlotIndex: timeSlotIndex,
                    )),
          );
          // If the reservation is successful, update the UI and notify the user
          if (result != null) {
            setState(() {
              _fetchMovies();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Reservation made for ${movie.title}'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // If no seats are available, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No seats available for this time slot.')),
          );
        }
      } catch (e) {
        // Handle errors that occur during the availability check
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to check availability: $e')),
        );
      }
    } else {
      // If no time slot is selected, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot to proceed with booking.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show a loading indicator while movies are being fetched
      body: _movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Display the background image of the currently selected movie
                Positioned.fill(
                  child: Image.network(
                    _movies[_current].thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                // Overlay a gradient on top of the background image for better readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.grey.shade50.withOpacity(1),
                          Colors.grey.shade50.withOpacity(0.8),
                          Colors.grey.shade50.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Carousel slider with the movie list
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: CarouselSlider.builder(
                      itemCount: _movies.length,
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.7,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.7,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          // Update the current movie index and reset selected time slot
                          setState(() {
                            _current = index;
                          });
                          movieIndex = index;
                          _selectedTimeSlot =
                              null; // Reset selected time slot when changing movie
                        },
                      ),
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        final movie = _movies[index];

                        // Display a card with movie details and booking button
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              MovieCard(
                                movie: movie,
                                onTimeSlotSelected:
                                    (TimeSlot? selectedTimeSlot) {
                                  _selectedTimeSlot = selectedTimeSlot;
                                },
                              ),
                              const SizedBox(height: 10),
                              // Button to proceed with booking the selected time slot
                              RoundedButton(
                                onPressed: selecTimeSlot,
                                btnName: 'Book',
                                color: Colors.amber,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
