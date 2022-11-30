class CreateRepostInput {
  String? audioMediaItem;
  String? commentOption;
  String? content;
  List<String>? hashTags;
  List<String>? imageMediaItems;
  String? location;
  List<String>? mentionList;
  String? postRating;
  String? repostedPostId;
  String? repostedPostOwnerId;
  String? videoMediaItem;

  CreateRepostInput(
      {this.audioMediaItem,
      this.commentOption,
      this.content,
      this.hashTags,
      this.imageMediaItems,
      this.location,
      this.mentionList,
      this.postRating,
      this.repostedPostId,
      this.repostedPostOwnerId,
      this.videoMediaItem});

  CreateRepostInput.fromJson(Map<String, dynamic> json) {
    audioMediaItem = json['audioMediaItem'];
    commentOption = json['commentOption'];
    content = json['content'];
    hashTags = json['hashTags'].cast<String>();
    imageMediaItems = json['imageMediaItems'].cast<String>();
    location = json['location'];
    mentionList = json['mentionList'].cast<String>();
    postRating = json['postRating'];
    repostedPostId = json['repostedPostId'];
    repostedPostOwnerId = json['repostedPostOwnerId'];
    videoMediaItem = json['videoMediaItem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['audioMediaItem'] = audioMediaItem;
    data['commentOption'] = commentOption;
    data['content'] = content;
    data['hashTags'] = hashTags;
    data['imageMediaItems'] = imageMediaItems;
    data['location'] = location;
    data['mentionList'] = mentionList;
    data['postRating'] = postRating;
    data['repostedPostId'] = repostedPostId;
    data['repostedPostOwnerId'] = repostedPostOwnerId;
    data['videoMediaItem'] = videoMediaItem;
    return data;
  }
}
