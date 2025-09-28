//Crear un reflejo de la tabla de la BD, por estandarzacion.
class MovieDao {
  int? idMovie;
  String? nameMovie;
  String? time;
  String? dateRelese;

  //El siguiente constructor se construir un objeto de tipo MovieDao
  //Contructor que normalmente siempre debemos crear. Son posicionales{}
  MovieDao({this.idMovie, this.nameMovie, this.time, this.dateRelese});


  //Constructor que construya objetos a apartir de un Map
  //El factory permite llamar a otro constructor desde este constructor
  factory MovieDao.fromMap(Map<String, dynamic> mapa) {
    //aqqui se esta llamando al constructor principal, en java no se permite esto
    return MovieDao(
      idMovie: mapa['idMovie'],
      nameMovie: mapa['nameMovie'],
      time: mapa['time'],
      dateRelese: mapa['dateRelese'],
    );
  }

  // Convertir de un objeto MovieDao a un Map
  Map<String, dynamic> toMap() {
    return {
      'idMovie': idMovie,
      'nameMovie': nameMovie,
      'time': time,
      'dateRelese': dateRelese,
    };
  }
}