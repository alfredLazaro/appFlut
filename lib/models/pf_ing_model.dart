class PfIng{
    final int? id;
    final String definicion;
    final String word;
    final String sentence;
    int learn;
    String? imageUrl = 'assets/img_defecto.jpg';
    String wordTranslat;
    String createdAt;
    String updatedAt;

    PfIng({
        this.id,
        required this.definicion,
        required this.word,
        required this.sentence,
        required this.learn,
        this.imageUrl = 'assets/img_defecto.jpg',
        required this.wordTranslat,
        required this.createdAt,
        required this.updatedAt, 
    });

    PfIng copyWith({
        int? id,
        String? word,
        String? definicion,
        String? sentence,
        int? learn,
        String? imageUrl,
        String? wordTranslat,
        String? createdAt,
        String? updatedAt,
      }) {
        return PfIng(
          id: id ?? this.id,
          word: word ?? this.word,
          definicion: definicion ?? this.definicion,
          sentence: sentence ?? this.sentence,
          learn: learn ?? this.learn,
          imageUrl: imageUrl ?? this.imageUrl,
          wordTranslat: wordTranslat ?? this.wordTranslat,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
        );
      }

    factory PfIng.fromMap(Map<String, dynamic> map){
        return PfIng(
            id: map['id'],
            definicion: map['definicion'],
            word: map['word'],
            sentence: map['sentence'],
            learn: map['learn'],
            imageUrl: map['image'],
            wordTranslat: map['wordTranslat'],
            createdAt: map['created_at'],
            updatedAt: map['updated_at'],
        );
    }

    Map<String, dynamic> toMap(){
        return {
            'definicion':definicion,
            'word':word,
            'sentence':sentence,
            'learn':learn,
            'image':imageUrl,
            'wordTranslat':wordTranslat,
            'created_at': createdAt,
            'updated_at': updatedAt,
        };
    }
    factory PfIng.fromJson(Map<String, dynamic> json){
      return PfIng(
        id: json['id'],
        definicion: json['definicion'],
        word: json['word'],
        sentence: json['sentence'],
        learn: json['learn'],
        imageUrl: json['image'],
        wordTranslat: json['wordTranslat'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
    }
}