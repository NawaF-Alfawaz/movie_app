import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config.dart';
import '../data/movie_repository.dart';
import '../data/reservation_repository.dart';
import '../models/movie.dart';
import 'widgets/roundedButton.dart';
import 'widgets/time_slot_card.dart';

// The ReservationScreen class is a stateful widget used for reserving a movie timeslot.
class ReservationScreen extends StatefulWidget {
  final String movieId; // Unique identifier of the movie.
  final TimeSlot timeSlot; // Information about the specific time slot.
  final int timeSlotIndex; // Index of the selected time slot.

  const ReservationScreen({
    super.key,
    required this.movieId,
    required this.timeSlot,
    required this.timeSlotIndex,
  });

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

// State class for ReservationScreen that manages user interactions and data changes.
class _ReservationScreenState extends State<ReservationScreen> {
  final TextEditingController _peopleController = TextEditingController();
  final MovieRepository _movieRepository = MovieRepository(baseUrl: baseUrl);
  final ReservationRepository _reservationRepository =
      ReservationRepository(baseUrl: baseUrl);

  // Function to book a timeslot with a given number of people.
  Future<void> bookTimeSlot(int numOfPeople) async {
    try {
      // Check if there are enough available seats for the requested number of people.
      final remainingCapacity = await _movieRepository.checkAvailability(
          widget.movieId, widget.timeSlotIndex);
      if (remainingCapacity >= numOfPeople) {
        // If enough capacity is available, proceed with the reservation.

        final result = await _reservationRepository.reserveTimeSlot(
            widget.movieId, widget.timeSlotIndex, numOfPeople);
        // If reservation is successful, navigate back to the previous screen.
        if (result != null) {
          Navigator.pop(context, true);
        }
      } else {
        // Show a snackbar message if not enough seats are available.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No seats available for this time slot.')),
        );
      }
    } catch (e) {
      // Show a snackbar message if an error occurs during the reservation process.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check availability: $e')),
      );
    }
  }

  Future<void> submitToBook() async {
    // Get the value entered for the number of people.
    final String peopleCount = _peopleController.text;
    if (peopleCount.isEmpty) {
      // If no value is entered, show a snackbar with an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the number of people.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      // Try parsing the entered value to an integer.
      final int? peopleCount = int.tryParse(_peopleController.text);
      // If the parsing is successful, call the bookTimeSlot function.
      await bookTimeSlot(peopleCount!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Formatting date and time for the selected timeslot.
    String formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(widget.timeSlot.startTime));
    String formattedStartTime =
        DateFormat('HH:mm').format(DateTime.parse(widget.timeSlot.startTime));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reserve Timeslot"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card to show selected timeslot details.
              TimeSlotCard(
                  formattedDate: formattedDate,
                  formattedStartTime: formattedStartTime),
              const SizedBox(height: 30),
              // Section to enter the number of people for the reservation.
              const Text(
                'Enter Number of People',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              // TextField to input the number of people.
              TextField(
                controller: _peopleController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g. 3',
                  filled: true,
                  fillColor: Colors.grey[200],
                  labelText: 'Number of People',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.group, color: Colors.amber),
                ),
              ),
              const SizedBox(height: 30),
              // Button to initiate the reservation.
              Center(
                child: RoundedButton(
                  btnName: "Reserve Now",
                  color: Colors.amber,
                  onPressed: submitToBook,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
