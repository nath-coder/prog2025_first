import 'package:flutter/material.dart';
import 'package:prog2025_firtst/models/api_movie_dao.dart';

class ItemMovieWidget extends StatelessWidget {
  ItemMovieWidget({super.key, required this.apiMovieDao});
  ApiMovieDao apiMovieDao;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: FadeInImage(
        placeholder: AssetImage('assets/mascota.png'),  
        image: NetworkImage('https://image.tmdb.org/t/p/w500/${apiMovieDao.posterPath}')
      )
    );
  }
}