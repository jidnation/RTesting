class Endpoints {
  static const String graphQLBaseUrl = "http://185.3.95.146:4000/graphql";
  // static const String graphQLBaseUrl = "https://live.myreach.me";
  // static const String gqlSubscriptionBaseUrl = "live.myreach.me/interaction";
  static const String gqlSubscriptionBaseUrl = "ws://185.3.95.146:4000/graphql";
  // static const String gqlSubscriptionBaseUrl =
  //     "ws://18.208.115.86:4400/graphql";

  //chat api
  static const String graphQLChatUrl = "http://185.3.95.146:4400/graphql";
  // static const String graphQLChatUrl = "http://18.208.115.86:4400/graphql";
  static const String gqlSubscriptionChatUrl =
      "wss://185.3.95.146:4400/graphql";
  // static const String gqlSubscriptionChatUrl =
  //     "wss://18.208.115.86:4400/graphql";

  //calls api
  // static const String graphQLNotificationUrl =
  //     'http://18.208.115.86:4400/graphql';
  static const String graphQLNotificationUrl =
      'http://185.3.95.146:4500/graphql';
}
