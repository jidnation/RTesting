class CommentModel {
  String? postId;
  String? authId;
  String? commentId;
  String? commentSlug;
  String? content;
  int? nComments;
  int? nLikes;

  CommentModel({
    this.postId,
    this.authId,
    this.commentId,
    this.commentSlug,
    this.content,
    this.nComments,
    this.nLikes,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        postId: json["postId"],
        authId: json["authId"],
        commentId: json["commentId"],
        commentSlug: json["commentSlug"],
        content: json["content"],
        nComments: json["nComments"],
        nLikes: json["nLikes"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "commentId": commentId,
        "commentSlug": commentSlug,
        "content": content,
        "nComments": nComments,
        "nLikes": nLikes,
      };
}

class CommentLikeModel {
  String? postId;
  String? authId;
  String? likeId;
  String? commentId;

  CommentLikeModel({
    this.postId,
    this.authId,
    this.likeId,
    this.commentId,
  });

  factory CommentLikeModel.fromJson(Map<String, dynamic> json) =>
      CommentLikeModel(
        postId: json["postId"],
        authId: json["authId"],
        likeId: json["likeId"],
        commentId: json["commentId"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "authId": authId,
        "likeId": likeId,
        "commentId": commentId,
      };
}