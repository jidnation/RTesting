class GetWordClass {
  GetWordClass({
    this.abbr,
    this.authId,
    this.meaning,
    this.word,
    this.wordId,
  });

  String? abbr;
  String? authId;
  String? meaning;
  String? word;
  String? wordId;

  factory GetWordClass.fromJson(Map<String, dynamic> json) => GetWordClass(
        abbr: json["abbr"] ?? '',
        authId: json["authId"] ?? '',
        meaning: json["meaning"] ?? '',
        word: json["word"] ?? '',
        wordId: json["wordId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "abbr": abbr,
        "authId": authId,
        "meaning": meaning,
        "word": word,
        "wordId": wordId,
      };
}
