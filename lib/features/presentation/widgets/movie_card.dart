import 'package:flutter/material.dart';
import '../../models/movie.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.onTimeSlotSelected,
  });

  final Movie movie;
  final Function(TimeSlot?) onTimeSlotSelected;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  TimeSlot? _selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: 200,
              margin: const EdgeInsets.only(top: 20),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(
                widget.movie.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.movie.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.movie.genre,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            // Add checkboxes for each time slot
            Container(
              child: Column(
                children: widget.movie.timeSlots.map((timeSlot) {
                  return Row(
                    children: [
                      Checkbox(
                        value: _selectedTimeSlot == timeSlot,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedTimeSlot = timeSlot;
                            } else {
                              _selectedTimeSlot = null;
                            }
                            widget.onTimeSlotSelected(_selectedTimeSlot);
                          });
                        },
                      ),
                      Text(
                        "${timeSlot.startTime} (${timeSlot.bookedCount}/${timeSlot.capacity} booked)",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        widget.movie.rating.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '2h',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
