import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config.dart';
import '../data/movie_repository.dart';
import '../data/reservation_repository.dart';
import '../models/movie.dart';
import 'widgets/roundedButton.dart';

class ReservationScreen extends StatefulWidget {
  final String movieId;
  final TimeSlot timeSlot;
  final int timeSlotIndex;
  const ReservationScreen(
      {super.key,
      required this.movieId,
      required this.timeSlot,
      required this.timeSlotIndex});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final TextEditingController _peopleController = TextEditingController();
  final MovieRepository _movieRepository = MovieRepository(baseUrl: baseUrl);
  final ReservationRepository _reservationRepository =
      ReservationRepository(baseUrl: baseUrl);

  Future<void> bookTimeSlot(int numOfPeople) async {
    try {
      final remainingCapacity = await _movieRepository.checkAvailability(
          widget.movieId, widget.timeSlotIndex);
      if (remainingCapacity >= numOfPeople) {
        final result = await _reservationRepository.reserveTimeSlot(
            widget.movieId, widget.timeSlotIndex, numOfPeople);

        if (result != null) {
          Navigator.pop(context, true);
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
  }

  @override
  Widget build(BuildContext context) {
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
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Time Slot',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            color: Colors.amber,
                            size: 24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Date: $formattedDate',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Time: $formattedStartTime',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Enter Number of People',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
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
              Center(
                child: RoundedButton(
                  btnName: "Reserve Now",
                  color: Colors.amber,
                  onPressed: () async {
                    final String peopleCount = _peopleController.text;
                    if (peopleCount.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter the number of people.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } else {
                      final int? peopleCount =
                          int.tryParse(_peopleController.text);

                      await bookTimeSlot(peopleCount!);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
