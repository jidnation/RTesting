class StreamResponse {
  String? token;
  String? channelName;

  StreamResponse({
    this.token,
    this.channelName
  });
  factory StreamResponse.fromJson(Map<String, dynamic> json) => StreamResponse(
    token: json["token"],
    channelName: json["channelName"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "channelName": channelName
  };
}