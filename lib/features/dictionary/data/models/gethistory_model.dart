class GetSearchedWordsHistory {
  GetSearchedWordsHistory(
      {this.word, this.createdAt, this.authId, this.historyId});

  String? word;
  String? createdAt;
  String? authId;
  String? historyId;

  factory GetSearchedWordsHistory.fromJson(Map<String, dynamic> json) =>
      GetSearchedWordsHistory(
        word: json["word"] ?? '',
        createdAt: json["created_at"] ?? '',
        authId: json["authId"] ?? '',
        historyId: json["historyId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "created_at": createdAt,
        "authId": authId,
        "historyId": historyId,
      };
}
