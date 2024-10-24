// Reservation model class
class Reservation {
  final String movieId;
  final int timeSlotIndex;
  final int numberOfPeople;
  final DateTime reservedAt;

  Reservation({
    required this.movieId,
    required this.timeSlotIndex,
    required this.numberOfPeople,
    required this.reservedAt,
  });

  // Convert a Reservation to JSON
  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'timeSlotIndex': timeSlotIndex,
      'numberOfPeople': numberOfPeople,
      'reservedAt': reservedAt.toIso8601String(),
    };
  }
}
