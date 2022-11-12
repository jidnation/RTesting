class GetRecentlyAddedWord {
  GetRecentlyAddedWord({
    this.abbr,
    this.authId,
    this.meaning,
    this.createdAt,
    this.language,
    this.word,
    this.wordId,
  });

  String? abbr;
  String? authId;
  String? meaning;
  String? createdAt;
  String? language;
  String? word;
  String? wordId;

  factory GetRecentlyAddedWord.fromJson(Map<String, dynamic> json) =>
      GetRecentlyAddedWord(
        abbr: json["abbr"] ?? 'NULL',
        authId: json["authId"] ?? 'NULL',
        meaning: json["meaning"] ?? 'NULL',
        createdAt: json["created_at"] ?? 'NULL',
        language: json["language"] ?? 'NULL',
        word: json["word"] ?? 'NULL',
        wordId: json["wordId"] ?? 'NULL',
      );

  Map<String, dynamic> toJson() => {
        "abbr": abbr,
        "authId": authId,
        "meaning": meaning,
        "created_at": createdAt,
        "language": language,
        "word": word,
        "wordId": wordId,
      };
}
