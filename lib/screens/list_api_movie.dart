import 'package:flutter/material.dart';
import 'package:prog2025_firtst/services/api_movies.dart';
import 'package:prog2025_firtst/widgets/item_movie_widget.dart';

class ListApiMovie extends StatefulWidget {
  const ListApiMovie({super.key});
  

  @override
  State<ListApiMovie> createState() => _ListApiMovieState();
}

class _ListApiMovieState extends State<ListApiMovie> {
  ApiMovies? apiMovies;
  
  @override
  void initState() {
    super.initState();
    apiMovies = ApiMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies from API'),
      ),
      body: FutureBuilder(
        future:apiMovies!.fetchMovies(),
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final movies = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverGrid.builder(
                  itemCount: movies.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .7,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return ItemMovieWidget(apiMovieDao: movies[index]);
                  },
                ),
              ],
            );
             /*GridView.builder(
              itemCount: movies.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                //childAspectRatio: 0.7,
                childAspectRatio: .8,

                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return ItemMovieWidget(apiMovieDao: movies[index]);
              },
            );*/
          }
        }
      )
    );    
  }
}