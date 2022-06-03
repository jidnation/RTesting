import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';

class ChatsListScreen extends StatefulHookWidget {
  static const String id = 'chats_list_screen';
  const ChatsListScreen({Key? key}) : super(key: key);

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _tabController = useTabController(initialLength: 2);
    final usersList = useState<List<ChatUser>>([]);
    final tailMessage = useState<List<Chat>>([]);
    final recipientUsers = useState<List<User>>([]);
    useMemoized(() {
      globals.chatBloc!.add(GetUserThreadsEvent(id: globals.user!.id));
    });
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: BlocConsumer<ChatBloc, ChatState>(
            bloc: globals.chatBloc,
            listener: (context, state) {
              if (state is GetUserThreadsSuccess) {
                usersList.value.clear();
                tailMessage.value.clear();
                recipientUsers.value.clear();
                for (var thread in state.userThreads!) {
                  for (var participant in thread.participantsInfo!) {
                    if (participant.id != globals.user!.id) {
                      usersList.value.add(participant);
                      globals.userBloc!
                          .add(GetRecipientProfileEvent(email: participant.id));
                    }
                  }
                  tailMessage.value.add(thread.tailMessage!);
                }
              }
            },
            builder: (context, state) {
              bool _isLoading = state is ChatLoading;
              return BlocConsumer<UserBloc, UserState>(
                bloc: globals.userBloc,
                listener: (context, state) {
                  if (state is RecipientUserData) {
                    recipientUsers.value.add(state.user!);
                  }
                },
                builder: (context, state) {
                  _isLoading = state is UserLoading;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.black,
                            ),
                            onPressed: () {
                              RouteNavigators.pop(context);
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/svgs/Setting.svg',
                              width: 23,
                              height: 23,
                              color: AppColors.textColor2,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        height: 48,
                        child: CustomRoundTextField(
                          hintText: 'Search Reach',
                          textCapitalization: TextCapitalization.characters,
                        ),
                      ).paddingSymmetric(h: 20),
                      const SizedBox(height: 25),
                      Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          TabBar(
                            indicatorWeight: 1.5,
                            indicatorColor: Colors.transparent,
                            unselectedLabelColor: AppColors.greyShade4,
                            labelColor: AppColors.textColor2,
                            controller: _tabController,
                            tabs: [
                              Tab(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _tabController.animateTo(0);
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _tabController.index == 0
                                          ? AppColors.textColor2
                                          : Colors.transparent,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        'General Reachout',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(15),
                                          fontWeight: FontWeight.w400,
                                          color: _tabController.index == 0
                                              ? AppColors.white
                                              : AppColors.textColor2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _tabController.animateTo(1);
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _tabController.index == 1
                                          ? AppColors.textColor2
                                          : Colors.transparent,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        'Starred Reachout',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(15),
                                          fontWeight: FontWeight.w400,
                                          color: _tabController.index == 1
                                              ? AppColors.white
                                              : AppColors.textColor2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      _isLoading
                          ? const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              ),
                            ).paddingOnly(t: 30)
                          : Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  usersList.value.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: usersList.value.length,
                                          itemBuilder: (context, index) {
                                            return ChatItem(
                                              recipientUser:
                                                  recipientUsers.value[index],
                                              id: usersList.value[index].id!,
                                              username: (usersList.value[index]
                                                          .firstName! +
                                                      ' ' +
                                                      usersList.value[index]
                                                          .lastName!)
                                                  .toTitleCase(),
                                              status: tailMessage
                                                  .value[index].value!,
                                              avatar: usersList
                                                  .value[index].profilePicture,
                                            );
                                          },
                                        ).paddingSymmetric(h: 14)
                                      : const EmptyChatListScreen(
                                          image:
                                              'assets/svgs/chat-list-empty.svg',
                                          title: 'Your general reachouts',
                                          subtitle:
                                              'Your reachouts will be listed here, that is those you are having a conversation with already',
                                        ),
                                  const EmptyChatListScreen(
                                    image: 'assets/svgs/chat-list-empty.svg',
                                    title: 'Your starred reachouts',
                                    subtitle:
                                        'Your reachouts will be listed here, that is those profile you starred and having a conversation with already',
                                  ),
                                ],
                              ),
                            )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem(
      {Key? key,
      required this.avatar,
      required this.status,
      required this.username,
      required this.id,
      this.recipientUser})
      : super(key: key);

  final String username;
  final String status;
  final String? avatar;
  final String? id;
  final User? recipientUser;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        RouteNavigators.route(
          context,
          MsgChatInterface(recipientUser: recipientUser),
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10),
      ),
      child: Row(
        children: [
          avatar == null
              ? ImagePlaceholder(
                  width: getScreenWidth(52),
                  height: getScreenHeight(52),
                )
              : RecipientProfilePicture(
                  width: getScreenWidth(52),
                  height: getScreenHeight(52),
                  imageUrl: avatar,
                ),
          const SizedBox(width: 13),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.greyShade3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
