class PfIng{
    final int id;
    final String word;
    final String sentence;

    PfIng({
        required this.id,
        required this.word,
        required this.sentence,
    });

    factory PfIng.fromMap(Map<String, dynamic> map){
        return PfIng(
            id: map['id'],
            word: map['word'],
            sentence: map['sentence'],
        );
    }

    Map<String, dynamic> toMap(){
        return {
            'id':id,
            'word':word,
            'sentence':sentence,
        };
    }
}