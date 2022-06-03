import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/graphql/gql_client.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/graphql/schemas/post_schema.dart';
import 'package:reach_me/core/services/graphql/schemas/user_schema.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
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
      Console.log('get user profile', result);
      Console.log('get user profile', result.data);
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
      Console.log('set username', result.data);
      return User.fromJson(result.data!['setUsername']);
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
      Console.log('set date of birth', result.data);
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
      Console.log('update user', result.data);
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
      Console.log('get All Users ', result.data);
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
      Console.log('reach user ', result.data);
      return result.data['reachUser'];
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> starUser({required String? userId}) async {
    String q = r'''
          mutation starUser($userIdToStar: String!) {
            starUser(userIdToStar: $userIdToStar) {
              starredId
              userId
            }
          }''';
    try {
      final result = await _client.mutate(gql(q), variables: {
        'userIdToStar': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('star user ', result.data);
      return result.data['starUser'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getReachRelationship({required String? userId}) async {
    String q = r'''
          query getReachRelationship($userIdToReach: String!) {
            getReachRelationship(userIdToReach: $userIdToReach)
          }''';
    try {
      final result = await _client.query(gql(q), variables: {
        'userIdToReach': userId,
      });
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get reach relationship ', result.data);
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
      Console.log('del reach relationship ', result.data);
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
      Console.log('get star relationship ', result.data);
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
      Console.log('del star relationship ', result.data);
      return result.data['deleteStarRelationship'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualReach>> getReachers() async {
    String q = r'''
          query getReachers() {
            getReachers() {
              reacher {
                ''' +
        UserSchema.schema +
        '''
              }
              reacherId
              reaching {
                ''' +
        UserSchema.schema +
        '''
              }
              reachingId
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get Reachers', result.data);
      var res = result.data['getReachers'] as List;
      final data = res.map((e) => VirtualReach.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualReach>> getReachings() async {
    String q = r'''
          query getReachings() {
            getReachings() {
              reacher {
                ''' +
        UserSchema.schema +
        '''
              }
              reacherId
              reaching {
                ''' +
        UserSchema.schema +
        '''
              }
              reachingId
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get reachings', result.data);
      var res = result.data['getReachings'] as List;
      final data = res.map((e) => VirtualReach.fromJson(e)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualStar>> getStarred() async {
    String q = r'''
          query getStarred() {
            getStarred() {
              reacher {
                ''' +
        UserSchema.schema +
        '''
              }
              reacherId
              reaching {
                ''' +
        UserSchema.schema +
        '''
              }
              reachingId
            }
          }''';
    try {
      final result = await _client.query(gql(q), variables: {});
      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }
      Console.log('get starreds', result.data);
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
    List<String>? imageMediaItems,
    String? videoMediaItem,
  }) async {
    String q = r'''
        mutation createPost(
          $audioMediaItem: String
          $commentOption: String!
          $content: String!
          $imageMediaItems: Boolean
          $showLocation: Boolean
          ) {
          createPost(
            postBody: {
              audioMediaItem: $audioMediaItem
              commentOption: $commentOption
              content: $content
              imageMediaItems: $imageMediaItems
          }) {
            ''' +
        PostSchema.schema +
        '''
          }
        }''';
    try {
      Map<String, dynamic> variables = {
        'commentOption': commentOption,
        'content': content,
      };

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
      Console.log('create post', result.data);
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
      Console.log('edit post', result.data);
      return PostModel.fromJson(result.data!['editContent']);
    } catch (e) {
      rethrow;
    }
  }

  Future<PostModel> deletePost({required String postId}) async {
    String q = r'''
        mutation deletePost($postId: String!) {
          deletePost(postId: $postId) {
            ''' +
        PostSchema.schema +
        '''
          }
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
      Console.log('delete post', result.data);
      return PostModel.fromJson(result.data!['deletePost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<PostLikeModel> likePost({required String? postId}) async {
    String q = r'''
        mutation likePost($postId: String!) {
          likePost(postId: $postId) {
           likeId
           authId
           postId
          }
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
      Console.log('like post', result.data);
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

      Console.log('unlike post', result.data);
      return result.data!['unlikePost'] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommentModel> commentOnPost({
    required String postId,
    required String content,
  }) async {
    String q = r'''
        mutation commentOnPost(
          $postId: String!
          $content: String!
          ) {
          commentOnPost(
            commentBody: {
              postId: $postId
              content: $content
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
      });

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      Console.log('comment on post', result.data);
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

      Console.log('delete comment on post', result.data);
      return CommentModel.fromJson(result.data!['deletePostComment']);
    } catch (e) {
      rethrow;
    }
  }

  Future<PostVoteModel> votePost({
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
          ){
            voteId
            authId
            postId
            voteType
          }
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {
          'postId': postId,
          'voteType': voteType,
        },
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      Console.log('delete post vote', result.data);
      return PostVoteModel.fromJson(result.data!['votePost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deletePostVote({required String? voteId}) async {
    String q = r'''
        mutation deletePostVote($voteId: String!) {
          deletePostVote(voteId: $voteId)
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {'voteId': voteId},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      Console.log('delete post vote', result.data);
      return result.data!['deletePostVote'] as String;
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
           likeId
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

      Console.log('like comment on post', result.data);
      return CommentLikeModel.fromJson(result.data!['likeCommentOnPost']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unlikeCommentOnPost({
    required String commentLikeId,
  }) async {
    String q = r'''
        mutation unlikeCommentOnPost(
          $postId: String!
          $commentLikeId: String!
          ) {
          unlikeCommentOnPost(
            postId: $postId
            commentLikeId: $commentLikeId
          )
        }''';
    try {
      final result = await _client.mutate(
        gql(q),
        variables: {'commentLikeId': commentLikeId},
      );

      if (result is GraphQLError) {
        throw GraphQLError(message: result.message);
      }

      Console.log('like comment on post', result.data);
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
      Console.log('check comment like', result.data);
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

      Console.log('check post like', result.data);
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

      Console.log('check post vote', result.data);
      return result.data!['checkPostVote'] as String;
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

      Console.log('get all comment likes', result.data);
      return (result.data!['getAllCommentLikes'] as List)
          .map((e) => CommentLikeModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VirtualCommentModel>> getAllCommentsOnPost({
    required String? postId,
  }) async {
    String q = r'''
        query getAllCommentsOnPost($postId: String!) {
          getAllCommentsOnPost(postId: $postId){
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

      Console.log('get all comments on post', result.data);
      return (result.data!['getAllCommentsOnPost'] as List)
          .map((e) => VirtualCommentModel.fromJson(e))
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

      Console.log('get all likes on post', result.data);
      return (result.data!['getLikesOnPost'] as List)
          .map((e) => VirtualPostLikeModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<VirtualPostModel> getPost({required String? postId}) async {
    String q = r'''
        query getPost($postId: String!) {
          getPost(postId: $postId){
              profile {
                ''' +
        UserSchema.schema +
        '''
            }
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

      Console.log('get post', result.data);
      return VirtualPostModel.fromJson(result.data!['getPost']);
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
      Console.log('get single comment on post', result.data);
      return VirtualCommentModel.fromJson(
          result.data!['getSingleCommentOnPost']);
    } catch (e) {
      rethrow;
    }
  }
}
