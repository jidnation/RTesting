import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostReactors extends HookWidget {
  const PostReactors({
    Key? key,
    required this.postId,
    required this.reactionType,
  }) : super(key: key);
  final String postId;
  final String reactionType;

  @override
  Widget build(BuildContext context) {
    final _loading = useState(true);
    final _reactors = useState<List<VirtualPostLikeModel>>([]);
    useEffect(() {
      if (reactionType == 'Like') {
        globals.socialServiceBloc!.add(GetLikesOnPostEvent(postId: postId));
      } else if (reactionType == 'Upvote') {
        globals.socialServiceBloc!
            .add(GetVotesOnPostEvent(postId: postId, voteType: 'Upvote'));
      } else {
        globals.socialServiceBloc!
            .add(GetVotesOnPostEvent(postId: postId, voteType: 'Downvote'));
      }
    }, []);

    return BlocConsumer<SocialServiceBloc, SocialServiceState>(
      bloc: globals.socialServiceBloc,
      listener: (context, state) {
        if (state is GetLikesOnPostError) {
          _loading.value = false;
          Snackbars.error(context, message: state.error);
        }
        if (state is GetVotesOnPostError) {
          _loading.value = false;
          Snackbars.error(context, message: state.error);
        }
        if (state is GetLikesOnPostSuccess) {
          _loading.value = false;
          _reactors.value = state.data ?? [];
        }
        if (state is GetVotesOnPostSuccess) {
          _loading.value = false;
          _reactors.value = (state.data ?? [])
              .map((e) => VirtualPostLikeModel(
                  authId: e.authId,
                  postId: e.postId,
                  profile: e.profile,
                  createdAt: e.createdAt))
              .toList();
        }
      },
      builder: (context, state) {
        return BlocConsumer<UserBloc, UserState>(
            bloc: globals.userBloc,
            listener: (context, state) {
              if (state is UserLoading) {}
              if (state is UserError) {
                RouteNavigators.pop(context);
                RouteNavigators.pop(context);
                Snackbars.error(context, message: state.error);
              }
            },
            builder: (context, state) {
              return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: _loading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : _reactors.value.isEmpty
                          ? const Center(
                              child: Text('No reactions found'),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  child: Text(
                                    reactionType == 'Like'
                                        ? 'People who liked this post:'
                                        : reactionType == 'Upvote'
                                            ? 'People who shouted out this post:'
                                            : 'People who shouted down this post:',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemBuilder: (c, i) {
                                          final reaction = _reactors.value[i];
                                          return ListTile(
                                            leading:
                                                Helper.renderProfilePicture(
                                                    reaction.profile
                                                        ?.profilePicture),
                                            // title: Text(
                                            //     '${reaction.profile?.firstName ?? ''} ${reaction.profile?.lastName ?? ''}',
                                            //     style: const TextStyle(
                                            //         fontSize: 16,
                                            //         color: Colors.black)),
                                            title: Text(
                                                reaction.profile?.username ??
                                                    'Nil',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black)),
                                            subtitle: Text(
                                                timeago.format(
                                                    reaction.createdAt!),
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                            tileColor: Colors.black,

                                            visualDensity:
                                                VisualDensity.compact,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 16),
                                          );
                                        },
                                        separatorBuilder: (c, i) => SizedBox(
                                              height: 0,
                                            ),
                                        itemCount: _reactors.value.length),
                                  ),
                                ),
                              ],
                            ));
            });
      },
    );
  }
}
