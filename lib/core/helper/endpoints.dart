class Endpoints {
  static const String graphQLBaseUrl2 =
      "http://ec2-18-208-115-86.compute-1.amazonaws.com:4000/graphql";
  static const String graphQLBaseUrl = "https://api.myreach.me";
  // static const String graphQLBaseUrl = "https://api.myreach.me";
  // static const String gqlSubscriptionBaseUrl = "live.myreach.me/interaction";
  static const String gqlSubscriptionBaseUrl = "ws://185.3.95.146:4000/graphql";
  // static const String gqlSubscriptionBaseUrl = graphQLBaseUrl;

  //chat api
  // static const String graphQLChatUrl = graphQLBaseUrl;
  static const String graphQLChatUrl = "http://185.3.95.146:4400/graphql";
  // static const String graphQLChatUrl = "live.myreach.me/interaction";
  // static const String gqlSubscriptionChatUrl = graphQLBaseUrl;

  static const String gqlSubscriptionChatUrl =
      "wss://185.3.95.146:4400/graphql";

  //calls api
  // static const String graphQLNotificationUrl = 'live.myreach.me/interaction';
  // static const String graphQLNotificationUrl = graphQLBaseUrl;

  static const String graphQLNotificationUrl =
      'http://185.3.95.146:4500/graphql';
}
