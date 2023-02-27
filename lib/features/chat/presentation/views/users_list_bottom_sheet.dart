import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';

class UsersListBottomSheet extends StatefulHookWidget {
  const UsersListBottomSheet({Key? key}) : super(key: key);

  @override
  State<UsersListBottomSheet> createState() => _UsersListBottomSheetState();
}

class _UsersListBottomSheetState extends State<UsersListBottomSheet> {
  final _userBloc = UserBloc();
  @override
  void initState() {
    super.initState();
    _userBloc
        .add(FetchAllUsersByNameEvent(limit: 50, pageNumber: 1, query: ''));
  }

  @override
  Widget build(BuildContext context) {
    final _users = useState<List<User>>([]);
    final _filteredUsers = useState<List<User>>([]);
    final _loadingUsers = useState(true);

    return BlocConsumer<UserBloc, UserState>(
        bloc: _userBloc,
        listener: (context, state) {
          if (state is FetchUsersSuccess) {
            if ((state.user ?? []).isEmpty) {
              Snackbars.success(context, message: 'No users found!');
              Navigator.pop(context);
            }
            _users.value = state.user ?? [];
            _filteredUsers.value = state.user ?? [];
            _loadingUsers.value = false;
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: CustomRoundTextField(
                    hintText: 'Search by username or name',
                    onChanged: (value) {
                      if (value.isEmpty) {
                        _filteredUsers.value = _users.value;
                      } else {
                        final tempList = _users.value
                            .where((e) =>
                                (e.username ?? '')
                                    .toLowerCase()
                                    .contains(value) ||
                                (e.firstName ?? '')
                                    .toLowerCase()
                                    .contains(value) ||
                                (e.lastName ?? '')
                                    .toLowerCase()
                                    .contains(value))
                            .toList();
                        _filteredUsers.value = tempList;
                      }
                    },
                  ),
                ),
                _loadingUsers.value
                    ? Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: SizedBox(
                              child: CircularProgressIndicator(
                            strokeWidth: 2,
                          )),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                            itemBuilder: (c, i) {
                              final _user = _filteredUsers.value[i];
                              return ListTile(
                                tileColor: AppColors.white,
                                onTap: () {
                                  Navigator.pop(context, _user);
                                },
                                title: Text(
                                  '@${_user.username}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                visualDensity: VisualDensity.compact,
                                leading: Helper.renderProfilePicture(
                                    _user.profilePicture,
                                    size: 40),
                                subtitle: Text(
                                  _user.lastSeen == null
                                      ? 'Inactive'
                                      : 'Active ${Helper.parseUserLastSeen(_user.lastSeen!)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.greyShade3,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (c, i) => SizedBox(height: 0),
                            itemCount: _filteredUsers.value.length),
                      )
              ],
            ),
          );
        });
  }
}
