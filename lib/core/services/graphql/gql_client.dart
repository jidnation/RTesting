import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:reach_me/core/helper/endpoints.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/graphql/gql_provider.dart';
import 'package:reach_me/core/services/graphql/logger_http_client.dart';
import 'package:reach_me/core/utils/app_globals.dart';

class GraphQLApiClient {
  GraphQLApiClient()
      : graphQLClient = ValueNotifier<GraphQLClient>(
          GraphQLClient(
            cache: GraphQLCache(store: InMemoryStore()),
            link: HttpLink(
              Endpoints.graphQLBaseUrl,
              httpClient: LoggerHttpClient(http.Client()),
              defaultHeaders: <String, String>{
                'Authorization': 'Bearer ${globals.token}',
              },
            ),
          ),
        );

  final ValueNotifier<GraphQLClient> graphQLClient;

  Future<dynamic> query(
    DocumentNode query, {
    required Map<String, dynamic> variables,
  }) async {
    final QueryResult result = await clientFor().value.query(
          QueryOptions(
            document: query,
            variables: variables,
          ),
        );

    if (result.exception != null) {
      Console.log('query exception', result.exception);
      if (result.exception!.linkException != null) {
        return const GraphQLError(message: "Something went wrong. Try again.");
      } else {
        if (result.exception != null) {
          dynamic myException =
              result.exception!.graphqlErrors.first.extensions!['exception'];

          bool isUnauthorized = myException['message']
                  .toString()
                  .contains('This endpoint requires authorization!')
              ? true
              : false;

          if (isUnauthorized) {
            //if user token has expired, redirect them to login & remove all stacked routes
            return const GraphQLError(
                message: "Your session has expired, please login again");
          }
          return result.exception!.graphqlErrors.first;
        }
      }
    }
    return result;
  }

  Future<dynamic> mutate(
    DocumentNode documentNode, {
    required Map<String, dynamic> variables,
  }) async {
    final QueryResult result = await clientFor()
        .value
        .mutate(MutationOptions(document: documentNode, variables: variables));

    Console.log('mutate ex', result.exception);
    Console.log('mutate data', result.data);

    if (result.exception != null) {
      Console.log('mutate exception', result.exception);
      if (result.exception!.linkException != null) {
        return const GraphQLError(message: "Something went wrong. Try again.");
      } else {
        dynamic myException =
            result.exception!.graphqlErrors.first.extensions!['exception'];
        bool isUnauthorized = myException['message']
                .toString()
                .contains('This endpoint requires authorization!')
            ? true
            : false;

        if (isUnauthorized) {
          //if user token has expired, redirect them to login & remove all stacked routes
          return const GraphQLError(
              message: "Your session has expired, please login again");
        }
        return result.exception!.graphqlErrors.first;
      }
    }
    return result;
  }

  //subscriptions
  Stream<QueryResult> subscription(DocumentNode document,
      {required Map<String, dynamic> variables, String? operationName}) {
    //  clientFor().value.cache.reset(); //reset cache

    final SubscriptionOptions operation = SubscriptionOptions(
      document: document,
      operationName: operationName,
      variables: variables,
    );

    final Stream<QueryResult> result = clientFor().value.subscribe(operation);
    return result;
  }
}

class GraphQLChatClient {
  GraphQLChatClient()
      : graphQLClient = ValueNotifier<GraphQLClient>(
          GraphQLClient(
            cache: GraphQLCache(store: InMemoryStore()),
            link: HttpLink(
              Endpoints.graphQLChatUrl,
              httpClient: LoggerHttpClient(http.Client()),
              defaultHeaders: <String, String>{
                'Authorization': 'Bearer ${globals.token}',
              },
            ),
          ),
        );

  final ValueNotifier<GraphQLClient> graphQLClient;

  Future<dynamic> query(
    DocumentNode query, {
    required Map<String, dynamic> variables,
  }) async {
    final QueryResult result = await chatClientFor().value.query(
          QueryOptions(
            document: query,
            variables: variables,
          ),
        );

    if (result.exception != null) {
      Console.log('query exception', result.exception);
      if (result.exception!.linkException != null) {
        return const GraphQLError(message: "Something went wrong. Try again.");
      } else {
        if (result.exception != null) {
          dynamic myException =
              result.exception!.graphqlErrors.first.extensions!['exception'];
          bool isUnauthorized = myException['message']
                  .toString()
                  .contains('This endpoint requires authorization!')
              ? true
              : false;

          if (isUnauthorized) {
            //if user token has expired, redirect them to login & remove all stacked routes
            return const GraphQLError(
                message: "Your session has expired, please login again");
          }
          return result.exception!.graphqlErrors.first;
        }
      }
    }
    return result;
  }

  Future<dynamic> mutate(
    DocumentNode documentNode, {
    required Map<String, dynamic> variables,
  }) async {
    final QueryResult result =
        await chatClientFor().value.mutate(MutationOptions(
              document: documentNode,
              variables: variables,
            ));

    if (result.exception != null) {
      Console.log('mutate exception', result.exception);
      if (result.exception!.linkException != null) {
        return const GraphQLError(message: "Something went wrong. Try again.");
      } else {
        dynamic myException =
            result.exception!.graphqlErrors.first.extensions!['exception'];
        bool isUnauthorized = myException['message']
                .toString()
                .contains('This endpoint requires authorization!')
            ? true
            : false;

        if (isUnauthorized) {
          //if user token has expired, redirect them to login & remove all stacked routes
          return const GraphQLError(
              message: "Your session has expired, please login again");
        }
        return result.exception!.graphqlErrors.first;
      }
    }
    return result;
  }

  //subscriptions
  Stream<QueryResult> subscribe(
    DocumentNode document, {
    required Map<String, dynamic> variables,
  }) {
    final SubscriptionOptions options = SubscriptionOptions(
      document: document,
      variables: variables,
    );
    final Stream<QueryResult> result = chatClientFor().value.subscribe(options);
    return result;
  }
}

class GraphQLNotificationClient {
  GraphQLNotificationClient()
      : graphQLClient = ValueNotifier<GraphQLClient>(
          GraphQLClient(
            cache: GraphQLCache(store: InMemoryStore()),
            link: HttpLink(
              Endpoints.graphQLNotificationUrl,
              httpClient: LoggerHttpClient(http.Client()),
              defaultHeaders: <String, String>{
                'Authorization': 'Bearer ${globals.token}',
              },
            ),
          ),
        );

  final ValueNotifier<GraphQLClient> graphQLClient;

  Future<dynamic> query(
    DocumentNode query, {
    required Map<String, dynamic> variables,
  }) async {
    final QueryResult result = await chatClientFor().value.query(
          QueryOptions(
            document: query,
            variables: variables,
          ),
        );

    if (result.exception != null) {
      Console.log('query exception', result.exception);
      if (result.exception!.linkException != null) {
        return const GraphQLError(message: "Something went wrong. Try again.");
      } else {
        if (result.exception != null) {
          dynamic myException =
              result.exception!.graphqlErrors.first.extensions!['exception'];
          bool isUnauthorized = myException['message']
                  .toString()
                  .contains('This endpoint requires authorization!')
              ? true
              : false;

          if (isUnauthorized) {
            //if user token has expired, redirect them to login & remove all stacked routes
            return const GraphQLError(
                message: "Your session has expired, please login again");
          }
          return result.exception!.graphqlErrors.first;
        }
      }
    }
    return result;
  }

  Future<dynamic> mutate(
    DocumentNode documentNode, {
    required Map<String, dynamic> variables,
  }) async {
    final QueryResult result =
        await chatClientFor().value.mutate(MutationOptions(
              document: documentNode,
              variables: variables,
            ));

    if (result.exception != null) {
      Console.log('mutate exception', result.exception);
      if (result.exception!.linkException != null) {
        return const GraphQLError(message: "Something went wrong. Try again.");
      } else {
        dynamic myException =
            result.exception!.graphqlErrors.first.extensions!['exception'];
        bool isUnauthorized = myException['message']
                .toString()
                .contains('This endpoint requires authorization!')
            ? true
            : false;

        if (isUnauthorized) {
          //if user token has expired, redirect them to login & remove all stacked routes
          return const GraphQLError(
              message: "Your session has expired, please login again");
        }
        return result.exception!.graphqlErrors.first;
      }
    }
    return result;
  }

  //subscriptions
  Stream<QueryResult> subscribe(
    DocumentNode document, {
    required Map<String, dynamic> variables,
  }) {
    final SubscriptionOptions options = SubscriptionOptions(
      document: document,
      variables: variables,
    );
    final Stream<QueryResult> result = chatClientFor().value.subscribe(options);
    return result;
  }
}
