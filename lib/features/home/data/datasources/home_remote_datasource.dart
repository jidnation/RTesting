import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/core/services/graphql/schemas/post_schema.dart';
import 'package:reach_me/core/services/graphql/schemas/status.schema.dart';
import 'package:reach_me/core/services/graphql/schemas/user_schema.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/dtos/create.status.dto.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/star_model.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';

// abstract class IHomeRemoteDataSource {
//   Future<User> createAccount({
//     required String email,
//     required String firstName,
//     required String lastName,
//     required String password,
//     String? phoneNumber,
//   });
// }

class HomeRemoteDataSource {
  HomeRemoteDataSource({GraphQLApiClient? client})
      : _client = client ?? GraphQLApiClient();
  final GraphQLApiClient _client;

  Future<User> getUserProfile({required String? email}) async {
    String q = r'''
        query getUserByIdOrEmail($prop: String!) {
          getUserByIdOrEmail(prop: $prop) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'prop': email,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return User.fromJson(result.data!['getUserByIdOrEmail']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> setUsername({required String? username}) async {
    String q = r'''
        mutation setUsername($username: String!) {
          setUsername(username: $username) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'username': username,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return User.fromJson(result.data!['setUsername']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateLastSeen({required String? userId}) async {
    String q = r'''
        mutation updateLastSeen($userId: String!) {
          updateLastSeen(userId: $userId) 
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'userId': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return result.data!['updateLastSeen'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteAccount() async {
    String q = r'''
        mutation {
          deleteAuth
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return result.data['deleteAuth'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> setDOB({required String? dob}) async {
    String q = r'''
        mutation setDateOfBirth($dateOfBirth: String!) {
          setDateOfBirth(dateOfBirth: $dateOfBirth) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'dateOfBirth': dob,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return User.fromJson(result.data!['setDateOfBirth']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUserProfile({
    String? dateOfBirth,
    String? bio,
    String? gender,
    String? location,
    bool? showContact,
    bool? showLocation,
    String? username,
    String? phone,
  }) async {
    String q = r'''
        mutation updateUser(
          $bio: String
          $dateOfBirth: String
          $gender: String
          $location: String
          $showContact: Boolean
          $showLocation: Boolean
          ) {
          updateUser(
            userData: {
              bio: $bio
              dateOfBirth: $dateOfBirth
              gender: $gender
              location: $location
              showContact: $showContact
              showLocation: $showLocation
          }) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      Map<String, dynamic> variables = {};

      if (bio != null) variables.putIfAbsent('bio', () => bio);
      if (dateOfBirth != null) {
        variables.putIfAbsent('dateOfBirth', () => dateOfBirth);
      }
      if (gender != null) variables.putIfAbsent('gender', () => gender);
      if (location != null) variables.putIfAbsent('location', () => location);
      if (showContact != null) {
        variables.putIfAbsent('showContact', () => showContact);
      }
      if (showLocation != null) {
        variables.putIfAbsent('showLocation', () => showLocation);
      }

      final result = await _client.mutate(
        gql(q),
        variables: variables,
      );
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return User.fromJson(result.data!['updateUser']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> setImage({
    required String? imageUrl,
    required String? type,
  }) async {
    String q = r'''
        mutation setImage(
          $imageUrl: String!
          $typeOfImageUpload: String!
          ) {
          setImage(
            imageUrl: $imageUrl
            typeOfImageUpload: $typeOfImageUpload
            ) {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'imageUrl': imageUrl,
        'typeOfImageUpload': type,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('set image', result.data);
      return User.fromJson(result.data!['setImage']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getAllUsersByName({
    required int? limit,
    required int? pageNumber,
    required String? query,
  }) async {
    String q = r'''
          query getAllUsers($limit: Int!, $name: String!, $pageNumber: Int!) {
            getAllUsers(limit: $limit, name: $name, pageNumber: $pageNumber) {
          ''' +
        UserSchema.schema +
        '''
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'limit': limit,
        'pageNumber': pageNumber,
        'name': query,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      final res = result.data['getAllUsers'] as List;
      final data = res.map((e) => User.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> reachUser({required String? userId}) async {
    String q = r'''
          mutation reachUser($userIdToReach: String!) {
            reachUser(userIdToReach: $userIdToReach) {
              reacherId
              reachingId
            }
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'userIdToReach': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data['reachUser'];
    } catch (e) {
      rethrow;
    }
  }

  Future<StarModel> starUser({required String? userId}) async {
    String q = r'''
          mutation starUser($userIdToStar: String!) {
            starUser(userIdToStar: $userIdToStar) {
             ''' +
        StarUserSchema.schema +
        '''
            }
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'userIdToStar': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return StarModel.fromJson(result.data['starUser']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getReachRelationship(
      {required String? userId, required String? type}) async {
    String q = r'''
          query getReachRelationship($userIdToReach: String!, $type: String!) {
            getReachRelationship(userIdToReach: $userIdToReach, typeOfRelationship: $type)
          }''';
    try {
      final result = await _client
          .query(gql(q), variables: {'userIdToReach': userId, 'type': type});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return result.data['getReachRelationship'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteReachRelationship({required String? userId}) async {
    String q = r'''
          mutation deleteReachRelationship($userIdToDelete: String!) {
            deleteReachRelationship(userIdToDelete: $userIdToDelete) 
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'userIdToDelete': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data['deleteReachRelationship'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getStarRelationship({required String? userId}) async {
    String q = r'''
          query getStarRelationship($userIdToStar: String!) {
            getStarRelationship(userIdToStar: $userIdToStar)
          }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'userIdToStar': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data['getStarRelationship'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteStarRelationship({required String? userId}) async {
    String q = r'''
          mutation deleteStarRelationship($starIdToDelete: String!) {
            deleteStarRelationship(starIdToDelete: $starIdToDelete) 
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'starIdToDelete': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data['deleteStarRelationship'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualReach>> getReachers({
    required int pageLimit,
    required int pageNumber,
    String? authId,
  }) async {
    String q = r'''
          query getReachers(
            $page_limit: Int!
            $page_number: Int!
            $authId: String
          ) {
            getReachers(
              page_limit: $page_limit
              page_number: $page_number
              authId: $authId
            ) {
              reacher {
                ''' +
        ReacherProfileSchema.schema +
        '''
              }
              reacherId
              reaching {
                ''' +
        ReacherProfileSchema.schema +
        '''
              }
              reachingId
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'page_limit': pageLimit,
        'page_number': pageNumber,
        'authId': authId,
      });
      Console.log('REACHERRRRRSSSS', result);
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      var res = result.data['getReachers'] as List;
      final data = res.map((e) => VirtualReach.fromJson(e)).toList();
      data.removeWhere((element) => element.reacher == null);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualReach>> getReachings({
    required int pageLimit,
    required int pageNumber,
    String? authId,
  }) async {
    String q = r'''
        query getReachings(
            $page_limit: Int!
            $page_number: Int!
            $authId: String
          ) {
            getReachings(
              page_limit: $page_limit
              page_number: $page_number
              authId: $authId
            ) {   
              reacher {
                ''' +
        ReacherProfileSchema.schema +
        '''
              }
              reacherId
              reaching {
                ''' +
        ReacherProfileSchema.schema +
        '''
              }
              reachingId
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'page_limit': pageLimit,
        'page_number': pageNumber,
        'authId': authId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      var res = result.data['getReachings'] as List;
      final data = res.map((e) => VirtualReach.fromJson(e)).toList();
      data.removeWhere((element) => element.reaching == null);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualStar>> getStarred({
    required int pageLimit,
    required int pageNumber,
    String? authId,
  }) async {
    //TODO: ADD AUTH ID TO QUERY
    String q = r'''
         query getStarred(
            $page_limit: Int!
            $page_number: Int!
            
          ) {
            getStarred(
              page_limit: $page_limit
              page_number: $page_number
              
            ) {   
              starred {
                ''' +
        StarProfileSchema.schema +
        '''
              }
              starredId
              user {
                ''' +
        StarProfileSchema.schema +
        '''
              }
              authId
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'page_limit': pageLimit,
        'page_number': pageNumber,
        // 'authId': authId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      var res = result.data['getStarred'] as List;
      final data = res.map((e) => VirtualStar.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }


  Future<PostModel> createPost({
    String? audioMediaItem,
    String? commentOption,
    String? content,
    String? location,
    List<String>? imageMediaItems,
    String? videoMediaItem,
  }) async {
    String q = r'''
        mutation createPost(
          $commentOption: String!
          $content: String
          $audioMediaItem: String
          $imageMediaItems: [String]
          $videoMediaItem: String
          $location: String!
          ) {
          createPost(
            postBody: {
              commentOption: $commentOption
              content: $content
              audioMediaItem: $audioMediaItem
              imageMediaItems: $imageMediaItems
              videoMediaItem: $videoMediaItem
              location: $location
          }) {
            ''' +
        PostSchema.schema +
        '''
          }
        }''';
    try {
      Map<String, dynamic> variables = {
        'commentOption': commentOption,
        'location': location,
      };
      if (content != null && content.isNotEmpty) {
        variables.putIfAbsent('content', () => content);
      }
      if (audioMediaItem != null) {
        variables.putIfAbsent('audioMediaItem', () => audioMediaItem);
      }
      if (imageMediaItems != null) {
        variables.putIfAbsent('imageMediaItems', () => imageMediaItems);
      }
      if (videoMediaItem != null) {
        variables.putIfAbsent('videoMediaItem', () => videoMediaItem);
      }

      final result = await _client.mutate(
        gql(q),
        variables: variables,
      );
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return PostModel.fromJson(result.data!['createPost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<PostModel> editContent({
    required String postId,
    required String content,
  }) async {
    String q = r'''
        mutation editContent(
          $postId: String!
          $content: String!
          ) {
          editContent(
            contentInput: {
              postId: $postId
              content: $content
          }) {
            ''' +
        PostSchema.schema +
        '''
          }
        }''';
    try {
      Map<String, dynamic> variables = {
        'postId': postId,
        'content': content,
      };

      final result = await _client.mutate(
        gql(q),
        variables: variables,
      );
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return PostModel.fromJson(result.data!['editContent']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deletePost({required String postId}) async {
    String q = r'''
        mutation deletePost($postId: String!) {
          deletePost(postId: $postId)
        }''';
    try {
      Map<String, dynamic> variables = {'postId': postId};

      final result = await _client.mutate(
        gql(q),
        variables: variables,
      );
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['deletePost'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<PostLikeModel> likePost({required String? postId}) async {
    String q = r'''
        mutation likePost($postId: String!) {
          likePost(postId: $postId){
            ''' +
        PostLikeSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {'postId': postId},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return PostLikeModel.fromJson(result.data!['likePost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unlikePost({required String? postId}) async {
    String q = r'''
        mutation unlikePost($postId: String!) {
          unlikePost(postId: $postId) 
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {'postId': postId},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['unlikePost'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommentModel> commentOnPost({
    required String postId,
    required String content,
    required String userId,
  }) async {
    String q = r'''
        mutation commentOnPost(
          $postId: String!
          $content: String!
          $userId: String!
          $location: String!
          ) {
          commentOnPost(
            commentBody: {
              postId: $postId
              content: $content
              userId: $userId
              location: $location
          }) {
            ''' +
        CommentSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'postId': postId,
        'content': content,
        'userId': userId,
        'location': globals.location ?? ' ',
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return CommentModel.fromJson(result.data!['commentOnPost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<CommentModel> deletePostComment({required String commentId}) async {
    String q = r'''
        mutation deletePostComment($commentId: String!) {
          deletePostComment(commentId: $commentId) {
            ''' +
        CommentSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {'commentId': commentId},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return CommentModel.fromJson(result.data!['deletePostComment']);
    } catch (e) {
      rethrow;
    }
  }

  Future<SavePostModel> savePost({required String postId}) async {
    String q = r'''
        mutation savePost($postId: String!) {
          savePost(postId: $postId) {
            ''' +
        SavePostSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {'postId': postId},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return SavePostModel.fromJson(result.data!['savePost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteSavedPost({required String postId}) async {
    String q = r'''
        mutation deleteSavedPost($postId: String!) {
          deleteSavedPost(postId: $postId) 
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {'postId': postId},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['deleteSavedPost'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SavePostModel>> getAllSavedPosts({
    required int pageLimit,
    required int pageNumber,
  }) async {
    String q = r'''
        query getAllSavedPosts(
          $page_limit: Int!
          $page_number: Int!
          ) {
          getAllSavedPosts(
            page_limit: $page_limit
            page_number: $page_number
            ) {
            ''' +
        SavePostSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(
        gql(q),
        variables: {
          'page_limit': pageLimit,
          'page_number': pageNumber,
        },
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return (result.data!['getAllSavedPosts'] as List)
          .map((e) => SavePostModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> votePost({
    required String postId,
    required String voteType,
  }) async {
    String q = r'''
        mutation votePost(
          $voteType: String!
          $postId: String!
          ) {
          votePost(
            postId: $postId
            voteType: $voteType
          )
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'postId': postId,
        'voteType': voteType,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['votePost'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deletePostVote({required String? voteId}) async {
    String q = r'''
        mutation deletePostVote($postId: String!) {
          deletePostVote(postId: $postId)
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {'postId': voteId},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['deletePostVote'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommentLikeModel> likeCommentOnPost({
    required String postId,
    required String commentId,
  }) async {
    String q = r'''
        mutation likeCommentOnPost(
          $postId: String!
          $commentId: String!
          ) {
          likeCommentOnPost(
            postId: $postId
            commentId: $commentId
          ) {
           authId
           commentId
           postId
          }
        }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'postId': postId,
        'commentId': commentId,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return CommentLikeModel.fromJson(result.data!['likeCommentOnPost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unlikeCommentOnPost({
    required String commentId,
    required String postId,
  }) async {
    String q = r'''
        mutation unlikeCommentOnPost(
          $commentId: String!
          $postId: String!
          ) {
          unlikeCommentOnPost(
             postId: $postId
            commentId: $commentId
          )
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {
          'commentId': commentId,
          'postId': postId,
        },
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['unlikeCommentOnPost'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkCommentLike({required String? commentLikeId}) async {
    String q = r'''
        query checkCommentLike($commentLikeId: String!) {
          checkCommentLike(commentLikeId: $commentLikeId)
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'commentLikeId': commentLikeId,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['checkCommentLike'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkPostLike({required String? postId}) async {
    String q = r'''
        query checkPostLike($postId: String!) {
          checkPostLike(postId: $postId)
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'postId': postId,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['checkPostLike'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> checkPostVote({required String? postId}) async {
    String q = r'''
        query checkPostVote($postId: String!) {
          checkPostVote(postId: $postId){
            voteType
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'postId': postId,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['checkPostVote']['voteType'] as String;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommentLikeModel>> getAllCommentLikes({
    required String? commentId,
  }) async {
    String q = r'''
        query getAllCommentLikes($commentId: String!) {
          getAllCommentLikes(commentId: $commentId){
            authId
            commentId
            postId
            likeId
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'commentId': commentId,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return (result.data!['getAllCommentLikes'] as List)
          .map((e) => CommentLikeModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommentModel>> getAllCommentsOnPost({
    required String? postId,
    required int? pageLimit,
    required int? pageNumber,
  }) async {
    String q = r'''
        query getAllCommentsOnPost(
          $postId: String!
          $page_limit: Int!
          $page_number: Int!
          ) {
          getAllCommentsOnPost(
            postId: $postId
            page_limit: $page_limit
            page_number: $page_number
            ){
               ''' +
        CommentSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'postId': postId,
        'page_limit': pageLimit,
        'page_number': pageNumber,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return (result.data!['getAllCommentsOnPost'] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommentModel>> getPersonalComments({
    String? authId,
    required int? pageLimit,
    required int? pageNumber,
  }) async {
    String q = r'''
        query getPersonalComments(
          $page_limit: Int!
          $page_number: Int!
       
          ) {
          getPersonalComments(
            page_limit: $page_limit
            page_number: $page_number
           
            ){
               ''' +
        CommentSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        // 'authId': authId,
        'page_limit': pageLimit,
        'page_number': pageNumber,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return (result.data!['getPersonalComments'] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualPostLikeModel>> getLikesOnPost({
    required String? postId,
  }) async {
    String q = r'''
        query getLikesOnPost($postId: String!) {
          getLikesOnPost(postId: $postId){
            profile {
                ''' +
        UserSchema.schema +
        '''
            }
            authId
            postId
            likeId
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'postId': postId,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return (result.data!['getLikesOnPost'] as List)
          .map((e) => VirtualPostLikeModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<PostModel> getPost({required String? postId}) async {
    String q = r'''
        query getPost($postId: String!) {
          getPost(postId: $postId){
               ''' +
        PostSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'postId': postId,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return PostModel.fromJson(result.data!['getPost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<VirtualCommentModel> getSingleCommentOnPost({
    required String? postId,
  }) async {
    String q = r'''
        query getSingleCommentOnPost($postId: String!) {
          getSingleCommentOnPost(postId: $postId){
              profile {
                ''' +
        UserSchema.schema +
        '''
            }
               ''' +
        CommentSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'postId': postId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return VirtualCommentModel.fromJson(
          result.data!['getSingleCommentOnPost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostFeedModel>> getPostFeed({
    required int? pageLimit,
    required int? pageNumber,
  }) async {
    String q = r'''
        query getPostFeed(
          $page_limit: Int!
          $page_number: Int!
          ) {
          getPostFeed(
            page_limit: $page_limit
            page_number: $page_number
          ){
              post {
                ''' +
        PostSchema.schema +
        '''
            }
               ''' +
        PostFeedSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'page_limit': pageLimit,
        'page_number': pageNumber,
      });
      // Console.log('RESSSSSPPOONSE', result);
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return (result.data!['getPostFeed'] as List)
          .map((e) => PostFeedModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostModel>> getAllPosts({
    required int? pageLimit,
    required int? pageNumber,
    String? authId,
  }) async {
    String q = r'''
        query getAllPosts(
          $page_limit: Int!
          $page_number: Int!
          $authId: String
          ) {
          getAllPosts(
            page_limit: $page_limit
            page_number: $page_number
            authId: $authId
          ){   
               ''' +
        PostSchema.schema +
        '''
          }
        }''';
    try {
      final Map<String, dynamic> variables = {
        'page_limit': pageLimit,
        'page_number': pageNumber,
      };
      if (authId != null) {
        variables.putIfAbsent('authId', () => authId);
      }
      final result = await _client.query(gql(q), variables: variables);

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return (result.data!['getAllPosts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<StatusModel> createStatus({
    required CreateStatusDto createStatusDto,
  }) async {
    String q = r'''
        mutation createStatus(
          $statusBody: CreateStatus!
          ) {
          createStatus(
            statusBody: $statusBody
          ){   
               ''' +
        StatusSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'statusBody': createStatusDto.toJson(),
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return StatusModel.fromJson(result.data!['createStatus']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteStatus({required String? statusId}) async {
    String q = r'''
        mutation deleteStatus($statusId: String!) {
          deleteStatus(statusId: $statusId)
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'statusId': statusId,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      return result.data!['deleteStatus'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StatusModel>> getAllStatus({
    required int? pageLimit,
    required int? pageNumber,
  }) async {
    String q = r'''
        query getAllStatus(
          $page_limit: Int!
          $page_number: Int!
          ) {
          getAllStatus(
            page_limit: $page_limit
            page_number: $page_number
          ){   
               ''' +
        StatusSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'page_limit': pageLimit,
        'page_number': pageNumber,
      });
      Console.log('ALL STATUS RESPONSE:', result);
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return (result.data!['getAllStatus'] as List)
          .map((e) => StatusModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<StatusModel> getStatus({required String? statusId}) async {
    String q = r'''
        query getStatus($statusId: String!) {
          getStatus(statusId: $statusId)
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'statusId': statusId,
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return StatusModel.fromJson(result.data!['getStatus']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StatusFeedModel>> getStatusFeed({
    required int? pageLimit,
    required int? pageNumber,
  }) async {
    String q = r'''
        query getStatusFeed(
          $page_limit: Int!
          $page_number: Int!
          ) {
          getStatusFeed(
            page_limit: $page_limit
            page_number: $page_number
          ){   
               ''' +
        StatusFeedSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'page_limit': pageLimit,
        'page_number': pageNumber,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      final tempList = (result.data!['getStatusFeed'] as List)
          .map((e) => StatusFeedModel.fromJson(e))
          .toList();
      List<StatusFeedModel> list = [];
      if (tempList.isNotEmpty) {
        final groupedList =
            tempList.first.status!.groupBy((item) => item.status!.authId!);
        groupedList.forEach((key, value) {
          list.add(StatusFeedModel(id: key, status: value.toList()));
        });
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> suggestUser() async {
    String q = r'''
        query suggestUser() {
          suggestUser() {
            ''' +
        UserSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      return (result.data['suggestUser'] as List)
          .map((e) => User.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProfileIndexModel>> searchProfile({
    required int? pageLimit,
    required int? pageNumber,
    required String? name,
  }) async {
    String q = r'''
        query searchProfile(
          $limit: Int!
          $pageNumber: Int!
          $name: String!
          ) {
          searchProfile(
            name: $name
            limit: $limit
            pageNumber: $pageNumber
          ){   
               ''' +
        ProfileIndexSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'limit': pageLimit,
        'pageNumber': pageNumber,
        'name': name,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('search profile', result.data);
      return (result.data!['searchProfile'] as List)
          .map((e) => ProfileIndexModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostFeedModel>> getLikedPosts({
    required int? pageLimit,
    required int? pageNumber,
    String? authId,
  }) async {
    String q = r'''
        query getLikedPosts(
          $page_limit: Int!
          $page_number: Int!
          $authId: String
          ) {
          getLikedPosts(
            page_limit: $page_limit
            page_number: $page_number
            authId: $authId
          ){   
             post {
                ''' +
        PostSchema.schema +
        '''
            }
               ''' +
        PostFeedSchema.schema +
        '''
          }
        }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'page_limit': pageLimit,
        'page_number': pageNumber,
        'authId': authId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get liked posts', result.data);
      return (result.data!['getLikedPosts'] as List)
          .map((e) => PostFeedModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
