import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/endpoints.dart';
import 'package:reach_me/core/utils/app_globals.dart';

String uuidFromObject(Object object) {
  if (object is Map<String, Object>) {
    final String typeName = object['__typename'] as String;
    final String id = object['id'].toString();
    return <String>[typeName, id].join('/');
  }
  return object.toString();
}

ValueNotifier<GraphQLClient> clientFor() {
  final HttpLink httpLink = HttpLink(
    Endpoints.graphQLBaseUrl,
    defaultHeaders: <String, String>{
      'Authorization': 'Bearer ${globals.token}',
    },
  );
  final AuthLink authLink = AuthLink(
    getToken: () => 'Bearer ${globals.token}',
  );

  Link link = authLink.concat(httpLink);

  final WebSocketLink websocketLink = WebSocketLink(
    Endpoints.gqlSubscriptionBaseUrl,
    config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(minutes: 5),
        delayBetweenReconnectionAttempts: const Duration(seconds: 1),
        queryAndMutationTimeout: const Duration(seconds: 40),
        initialPayload: () => {'Authorization': 'Bearer ${globals.token}'}),
  );

  link = link.concat(websocketLink);

  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    ),
  );
}

///////////////////////////////////////////////
//////////////////////////////////////////////
//CHAT GQL CLIENT
ValueNotifier<GraphQLClient> chatClientFor() {
  final HttpLink httpLink = HttpLink(
    Endpoints.graphQLChatUrl,
    defaultHeaders: <String, String>{
      'Authorization': 'Bearer ${globals.token}',
    },
  );

  final AuthLink authLink = AuthLink(
    getToken: () => 'Bearer ${globals.token}',
  );

  Link link = authLink.concat(httpLink);

  final WebSocketLink websocketLink = WebSocketLink(
    Endpoints.gqlSubscriptionChatUrl,
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: const Duration(minutes: 5),
      delayBetweenReconnectionAttempts: const Duration(seconds: 1),
      queryAndMutationTimeout: const Duration(seconds: 40),
      initialPayload: () => {'Authorization': 'Bearer ${globals.token}'},
    ),
  );

  link = link.concat(websocketLink);

  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    ),
  );
}

///notification gql client

ValueNotifier<GraphQLClient> notificationClientFor() {
  final HttpLink httpLink = HttpLink(
    Endpoints.graphQLNotificationUrl,
    defaultHeaders: <String, String>{
      'Authorization': 'Bearer ${globals.token}',
    },
  );
  final AuthLink authLink = AuthLink(
    getToken: () => 'Bearer ${globals.token}',
  );

  Link link = authLink.concat(httpLink);

  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    ),
  );
}
