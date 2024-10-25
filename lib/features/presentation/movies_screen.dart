import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../data/movie_repository.dart';
import '../models/movie.dart';
import 'reservation_screen.dart';
import 'widgets/movie_card.dart';
import 'widgets/roundedButton.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  int _current = 0; // Start with first movie
  int movieIndex = 0;
  TimeSlot? _selectedTimeSlot;
  List<Movie> _movies = [];
  final MovieRepository _movieRepository = MovieRepository(baseUrl: baseUrl);

  @override
  void initState() {
    super.initState();
    _fetchMovies(); // Fetch the movies when the widget is initialized
  }

  Future<void> _fetchMovies() async {
    try {
      print("_fetchMovies");
      final movies = await _movieRepository.listMovies();
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      // Handle error, e.g. show a snackbar or error widget
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load movies: $e')),
      );
    }
  }

  Future<void> selecTimeSlot() async {
    if (_selectedTimeSlot != null) {
      final movie = _movies[movieIndex];
      try {
        final timeSlotIndex = movie.timeSlots.indexOf(_selectedTimeSlot!);
        final remainingCapacity =
            await _movieRepository.checkAvailability(movie.id, timeSlotIndex);
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
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Reservation made for ${movie.title}'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No seats available for this time slot.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to check availability: $e')),
        );
      }
    } else {
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
      body: _movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    _movies[_current].thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
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
