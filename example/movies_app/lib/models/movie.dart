import 'package:equatable/equatable.dart';

String genreToString(MovieGenre genre) {
  return genre.toString().split('.').last;
}


enum MovieGenre {
  comedy,
  thriller,
  drama,
  biography,
}


class Movie extends Equatable {
  final String title;
  final MovieGenre genre;
  final int year;
  final String imageUrl;

  Movie({this.title, this.genre, this.year, this.imageUrl});

  @override
  List<Object> get props => [title, genre, year];

}