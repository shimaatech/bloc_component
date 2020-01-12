import '../models/models.dart';

class MoviesRepository {
  static final List<Movie> movies = [
    Movie(
        title: 'Star Wars: A New Hope',
        genre: MovieGenre.drama,
        year: 1972,
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UY209_CR3,0,140,209_AL_.jpg'),
    Movie(
        title: 'The Shawshank Redemption',
        genre: MovieGenre.drama,
        year: 1994,
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZmNhMC00ZDIzLWFmNTEtODM1ZmRlYWMwMWFmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_UY209_CR0,0,140,209_AL_.jpg'),
    Movie(
        title: "Schindler's List",
        genre: MovieGenre.biography,
        year: 1993,
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BNDE4OTMxMTctNmRhYy00NWE2LTg3YzItYTk3M2UwOTU5Njg4XkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_UX140_CR0,0,140,209_AL_.jpg'),
    Movie(
        title: 'Raging Bull',
        genre: MovieGenre.biography,
        year: 1980,
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BYjRmODkzNDItMTNhNi00YjJlLTg0ZjAtODlhZTM0YzgzYThlXkEyXkFqcGdeQXVyNzQ1ODk3MTQ@._V1_UY209_CR1,0,140,209_AL_.jpg'),
    Movie(
        title: 'Casablanca ',
        genre: MovieGenre.drama,
        year: 1942,
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BY2IzZGY2YmEtYzljNS00NTM5LTgwMzUtMzM1NjQ4NGI0OTk0XkEyXkFqcGdeQXVyNDYyMDk5MTU@._V1_UX140_CR0,0,140,209_AL_.jpg'),
    Movie(
        title: 'Lawrence of Arabia',
        genre: MovieGenre.biography,
        year: 1962,
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BYWY5ZjhjNGYtZmI2Ny00ODM0LWFkNzgtZmI1YzA2N2MxMzA0XkEyXkFqcGdeQXVyNjUwNzk3NDc@._V1_UY209_CR2,0,140,209_AL_.jpg'),
    Movie(
        title: 'Vertigo',
        genre: MovieGenre.thriller,
        year: 1958,
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BYTE4ODEwZDUtNDFjOC00NjAxLWEzYTQtYTI1NGVmZmFlNjdiL2ltYWdlL2ltYWdlXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UX140_CR0,0,140,209_AL_.jpg'),
    Movie(
        title: 'Psycho',
        genre: MovieGenre.thriller,
        year: 1960,
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BNTQwNDM1YzItNDAxZC00NWY2LTk0M2UtNDIwNWI5OGUyNWUxXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UY209_CR0,0,140,209_AL_.jpg'),
    Movie(
        title: 'American Graffiti',
        genre: MovieGenre.comedy,
        year: 1973,
        imageUrl:
            'https://m.media-amazon.com/images/M/MV5BMjI5NjM5MjIyNF5BMl5BanBnXkFtZTgwNjg2MTUxMDE@._V1_UY209_CR0,0,140,209_AL_.jpg')
  ];

  Future<List<Movie>> fetchMovies() async {
    // mimic a rest request delay...
    await Future.delayed(Duration(milliseconds: 500));
    return List.from(movies);
  }
}
