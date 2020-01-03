import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/pelicula_provider.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class DataSearch extends SearchDelegate{

  String seleccion;
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Star wars',
    'Flash',
    'Ratatouille',
    'Stunami',
    'La fiesta de las salchichas',
    'Spiderman',
    'Capitán América'
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitán América'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones del AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.orange,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    if(query.isEmpty){
      return Container();
    }else{
      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if(snapshot.hasData){

            return ListView(
              children: snapshot.data.map((peli){
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(peli.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(peli.title),
                  subtitle: Text(peli.originalTitle),
                  onTap: (){
                    close(context, null);
                    peli.uniqueId = '${peli.id}.busqueda';
                    Navigator.pushNamed(context, 'detalle', arguments: peli);
                  },
                );
              }).toList()
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      );
    }
  }
  
/* 
  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    final listaSugerida = (query.isEmpty)
                            ? peliculasRecientes
                            : peliculas.where(
                                (p)=>p.toLowerCase().startsWith(query.toLowerCase())
                              ).toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i){
        return ListTile(
          leading: Icon(Icons.movie),
          title:  Text(listaSugerida[i]),
          onTap: (){
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  }
   */
}