class CreateStatusDto {
  String? alignment;
  String? audioMedia;
  String? background;
  String caption;
  String? content;
  String? font;
  String? imageMedia;
  String type;
  String? videoMedia;

  CreateStatusDto({
    this.alignment,
    this.audioMedia,
    this.background,
    required this.caption,
    this.content,
    this.font,
    this.imageMedia,
    this.videoMedia,
    required this.type,
  });

  factory CreateStatusDto.fromJson(Map<String, dynamic> json) =>
      CreateStatusDto(
        alignment: json["alignment"],
        audioMedia: json["audioMedia"],
        background: json["background"],
        caption: json["caption"],
        content: json["content"],
        font: json["font"],
        imageMedia: json["imageMedia"],
        type: json["type"],
        videoMedia: json["videoMedia"],
      );

  Map<String, dynamic> toJson() => {
        "alignment": alignment,
        "audioMedia": audioMedia,
        "background": background,
        "caption": caption,
        "content": content,
        "font": font,
        "imageMedia": imageMedia,
        "type": type,
        "videoMedia": videoMedia,
      };
}
