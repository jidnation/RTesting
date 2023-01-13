import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';

class PostReactors extends HookWidget {
  const PostReactors({
    Key? key,
    required this.postId,
  }) : super(key: key);
  final String postId;

  @override
  Widget build(BuildContext context) {
    final _loading = useState(true);
    final _reactors = useState<List<VirtualPostLikeModel>>([]);
    useEffect(() {
      globals.socialServiceBloc!.add(GetLikesOnPostEvent(postId: postId));
    }, []);

    return BlocConsumer<SocialServiceBloc, SocialServiceState>(
      bloc: globals.socialServiceBloc,
      listener: (context, state) {
        if (state is GetLikedPostsError) {
          _loading.value = false;
        }
        if (state is GetLikesOnPostSuccess) {
          _loading.value = false;
          _reactors.value = state.data ?? [];
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
                    color: AppColors.greyShade7,
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
                          ? Center(
                              child: Text('No one has liked this post'),
                            )
                          : ListView.separated(
                              itemBuilder: (c, i) {
                                final user = _reactors.value[i];
                                return ListTile(
                                  leading: Helper.renderProfilePicture(
                                      user.profile?.profilePicture),
                                  title: Text(user.profile?.username ?? ''),
                                  subtitle: Text(
                                      user.profile?.location ?? 'No Location'),
                                );
                              },
                              separatorBuilder: (c, i) => SizedBox(
                                    height: 8,
                                  ),
                              itemCount: _reactors.value.length));
            });
      },
    );
  }
}
