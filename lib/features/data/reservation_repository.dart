import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservation.dart';

class ReservationRepository {
  final String baseUrl;

  // Constructor to initialize the base URL
  ReservationRepository({required this.baseUrl});

  // Method to reserve a time slot for a movie
  Future<Reservation?> reserveTimeSlot(
      String movieId, int timeSlotIndex, int numberOfPeople) async {
    try {
      // Update booked count for the movie time slot
      final response = await http.post(
        Uri.parse('$baseUrl/reservations/reserve'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'numberOfPeople': numberOfPeople,
          'movieId': movieId,
          'timeSlotIndex': timeSlotIndex
        }),
      );
      print(response);
      if (response.statusCode == 201) {
        final newReservation = Reservation(
          movieId: movieId,
          timeSlotIndex: timeSlotIndex,
          numberOfPeople: numberOfPeople,
          reservedAt: DateTime.now(),
        );
        return newReservation;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error reserving time slot: \$e');
    }
  }
}
