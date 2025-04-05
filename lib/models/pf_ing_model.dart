class PfIng{
    final int? id;
    final String definicion;
    final String word;
    final String sentence;
    int learn;
    String createdAt;
    String updatedAt;

    PfIng({
        this.id,
        required this.definicion,
        required this.word,
        required this.sentence,
        required this.learn,
        required this.createdAt,
        required this.updatedAt,
    });

    factory PfIng.fromMap(Map<String, dynamic> map){
        return PfIng(
            id: map['id'],
            definicion: map['definicion'],
            word: map['word'],
            sentence: map['sentence'],
            learn: map['learn'],
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
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
    }
}