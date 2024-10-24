class Movie {
  final String id;
  final String title;
  final String genre;
  final double rating;
  final String thumbnailUrl;
  final List<TimeSlot> timeSlots;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.thumbnailUrl,
    required this.timeSlots,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'] ?? 'Unknown ID', // Provide a default value if id is null
      title: json['title'] ??
          'Unknown Title', // Provide a default value if title is null
      genre: json['genre'] ??
          'Unknown Genre', // Provide a default value if genre is null
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 0.0, // Handle null rating
      thumbnailUrl: json['thumbnailUrl'] ??
          '', // Provide a default value if thumbnailUrl is null
      timeSlots: (json['timeSlots'] as List<dynamic>? ??
              []) // Handle null or empty timeSlots list
          .map((slot) => TimeSlot.fromJson(slot as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TimeSlot {
  final String startTime;
  final int capacity;
  final int bookedCount;

  TimeSlot({
    required this.startTime,
    required this.capacity,
    required this.bookedCount,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime:
          json['startTime'] ?? 'Unknown Start Time', // Handle null startTime
      capacity: json['capacity'] ?? 0, // Default to 0 if capacity is null
      bookedCount:
          json['bookedCount'] ?? 0, // Default to 0 if bookedCount is null
    );
  }
}
