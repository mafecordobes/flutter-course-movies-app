import 'package:flutter/material.dart';
import 'package:movies_course/src/models/movies_model.dart';
import 'package:movies_course/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  String selection = '';
  final moviesProvider = new MovieProvider();
  final movies = [
    'After',
    'After We Collided',
    'Fangirl',
    'Spiderman',
    'Capitan America'
  ];
  final recentsMovies = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro app bar (como el icono de cancelar)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // CRea los resultados que se muestran
    return Center(
        child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.pink,
            child: Text(selection)));
  }

  /*@override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando se escribe
    final suggestList = (query.isEmpty)
        ? recentsMovies
        : movies
            .where((element) =>
                element.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(suggestList[index]),
          onTap: () {
            selection = suggestList[index];
            showResults(context);
          },
        );
      },
    );
  }*/

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando se escribe
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder(
        future: moviesProvider.searchMovie(query),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data;
            return ListView(
              children: movies.map((movie) {
                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(movie.getPosterImg()),
                    fit: BoxFit.contain,
                    width: 50.0,
                  ),
                  title: Text(movie.title),
                  subtitle: Text(movie.originalTitle),
                  onTap: () {
                    close(context, null);
                    movie.uniqueId = '';
                    Navigator.pushNamed(context, 'detalle', arguments: movie);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }
}
