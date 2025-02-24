class PfIng{
    final int? id;
    final String word;
    final String sentence;
    final int learn;

    PfIng({
        this.id,
        required this.word,
        required this.sentence,
        required this.learn,
    });

    factory PfIng.fromMap(Map<String, dynamic> map){
        return PfIng(
            id: map['id'],
            word: map['word'],
            sentence: map['sentence'],
            learn: map['learn'],
        );
    }

    Map<String, dynamic> toMap(){
        return {
            'word':word,
            'sentence':sentence,
            'learn':learn,
        };
    }
}