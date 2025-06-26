class Image{
  String? id;
  int? wordId;
  String nameImg;
  String? url;
  String? author;
  String? source;

  Image({
    this.id,
    this.wordId,
    required this.nameImg,
    this.url,
    this.author,
    this.source
  });
  //convertir un objeto en un mapa (para insertar en la base de datos)
  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'wordId': wordId,
      'nameImg': nameImg,
      'url': url,
      'author': author,
      'source': source
    };
  }
  //crear un objeto desde un map (desde la base de datos)
  factory Image.fromMap(Map<String,dynamic> map){
    return Image(
      id: map['id'],
      wordId: map['wordId'],
      nameImg: map['nameImg'],
      url: map['url'],
      author: map['author'],
      source: map['source']
    );
  }
}