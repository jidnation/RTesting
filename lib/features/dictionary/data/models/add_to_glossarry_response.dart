class AddWordToGlossaryResponse {
  AddWordToGlossaryResponse({
    this.abbr,
    this.meaning,
    this.authId,
    this.createdAt,
    this.language,
    this.word,
    this.wordId,
  });

  String? abbr;
  String? meaning;
  String? authId;
  String? createdAt;
  String? language;
  String? word;
  String? wordId;

  factory AddWordToGlossaryResponse.fromJson(Map<String, dynamic> json) =>
      AddWordToGlossaryResponse(
        abbr: json["abbr"],
        meaning: json["meaning"],
        authId: json["authId"],
        createdAt: json["created_at"],
        language: json["language"],
        word: json["word"],
        wordId: json["wordId"],
      );

  Map<String, dynamic> toJson() => {
        "abbr": abbr,
        "meaning": meaning,
        "authId": authId,
        "created_at": createdAt,
        "language": language,
        "word": word,
        "wordId": wordId,
      };
}
