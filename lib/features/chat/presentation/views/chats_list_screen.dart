import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
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
  Set<int> active = {};

  handleTap(int index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
    return active;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _tabController = useTabController(initialLength: 2, initialIndex: 0);
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
                    RouteNavigators.route(
                      context,
                      MsgChatInterface(recipientUser: state.user),
                    );
                  }
                  if (state is UserError) {
                    Snackbars.error(context, message: state.error);
                  }
                },
                builder: (context, state) {
                  bool _isLoadingUser = state is UserLoading;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/svgs/back.svg',
                              color: AppColors.black,
                            ),
                            onPressed: () {
                              RouteNavigators.pop(context);
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/svgs/message-plus.svg',
                                  width: 23,
                                  height: 23,
                                ),
                                onPressed: () {},
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
                        ],
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        height: 48,
                        child: CustomRoundTextField(
                          hintText: 'Search general reachout',
                          textCapitalization: TextCapitalization.characters,
                        ),
                      ).paddingSymmetric(h: 20),
                      const SizedBox(height: 25),
                      Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          TabBar(
                            isScrollable: false,
                            indicatorWeight: 1.5,
                            indicatorColor: Colors.transparent,
                            unselectedLabelColor: AppColors.textColor2,
                            labelColor: AppColors.white,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.textColor2,
                            ),
                            controller: _tabController,
                            tabs: [
                              Tab(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _tabController.animateTo(0);
                                  }),
                                  child: FittedBox(
                                    child: Text(
                                      'General Reachout',
                                      style: TextStyle(
                                        fontSize: getScreenHeight(15),
                                        fontWeight: FontWeight.w400,
                                        
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
                                  child: FittedBox(
                                    child: Text(
                                      'Starred Reachout',
                                      style: TextStyle(
                                        fontSize: getScreenHeight(15),
                                        fontWeight: FontWeight.w400,
                                        
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      _isLoadingUser
                          ? const LinearLoader(color: AppColors.black)
                              .paddingOnly(t: 10)
                          : const SizedBox.shrink(),
                      _isLoading
                          ? const Center( 
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                    backgroundColor: AppColors.black,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white)),
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
                                              onTap: () {
                                                handleTap(index);
                                                if (active.contains(index)) {
                                                  globals.userBloc!.add(
                                                      GetRecipientProfileEvent(
                                                          email: usersList
                                                              .value[index]
                                                              .id!));
                                                }
                                              },
                                              id: usersList.value[index].id!,
                                              username:
                                                  '@${usersList.value[index].username}',
                                              status: tailMessage
                                                  .value[index].value!,
                                              avatar: usersList
                                                  .value[index].profilePicture,
                                            ).paddingOnly(b: 5);
                                          },
                                        ).paddingOnly(r: 14, l: 14, t: 10)
                                      : const EmptyChatListScreen(
                                          image:
                                              'assets/svgs/chat-list-empty.svg',
                                          title: 'Your general reachouts',
                                          subtitle:
                                              'Your reachouts will be listed here, that is those you\nare having a conversation with already',
                                        ),
                                  const EmptyChatListScreen(
                                    image: 'assets/svgs/chat-list-empty.svg',
                                    title: 'Your starred reachouts',
                                    subtitle:
                                        'Your reachouts will be listed here, that is those profile you\nstarred and having a conversation with already',
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
      this.onTap})
      : super(key: key);

  final String username;
  final String status;
  final String? avatar;
  final String? id;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10),
      ),
      child: Row(
        children: [
          avatar == null
              ? ImagePlaceholder(
                  width: getScreenWidth(45),
                  height: getScreenHeight(45),
                )
              : RecipientProfilePicture(
                  width: getScreenWidth(45),
                  height: getScreenHeight(45),
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
              Container(
                constraints: BoxConstraints(maxWidth: getScreenWidth(250)),
                child: Text(
                  status,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.greyShade3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
