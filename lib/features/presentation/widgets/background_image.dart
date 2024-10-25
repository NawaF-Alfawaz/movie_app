import 'package:flutter/material.dart';

import '../../models/movie.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
    required List<Movie> movies,
    required int current,
  })  : _movies = movies,
        _current = current;

  final List<Movie> _movies;
  final int _current;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        _movies[_current].thumbnailUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
