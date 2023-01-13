class InitiateCallResponse {
  final String token;
  final String channel;

  const InitiateCallResponse({
    required this.channel,
    required this.token,
  });

  factory InitiateCallResponse.fromJson(Map<String, dynamic> json) =>
      InitiateCallResponse(
        channel: json["channelName"],
        token: json["token"],
      );
}