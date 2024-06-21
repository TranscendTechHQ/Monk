import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/auth/auth_provider.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/pages/widgets/user-mention/users.provider.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/cache_image.dart';
import 'package:frontend/ui/widgets/kit/alert.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';
import 'package:openapi/openapi.dart';

class TeamTaskModal extends ConsumerStatefulWidget {
  const TeamTaskModal({
    super.key,
  });

  static Future<T?> show<T>(BuildContext context) async {
    return await Alert.dialog<T>(
      context,
      child: const TeamTaskModal(),
      barrierDismissible: true,
    );
  }

  @override
  TeamTaskModelState createState() => TeamTaskModelState();
}

class TeamTaskModelState extends ConsumerState<TeamTaskModal> {
  bool isSearching = false;
  String? searchType;
  @override
  void initState() {
    super.initState();

    ref.read(usersProvider.notifier);
  }

  void openThread(BuildContext context, String name, String userId) {
    Navigator.pop(context);
    Navigator.push(
      context,
      ThreadPage.launchRoute(
        topic: "${name.replaceAll(' ', '_')}_${userId.substring(0, 4)}"
            .toLowerCase(),
        type: 'todo',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allUsers = ref.watch(usersProvider);
    return Container(
      constraints: BoxConstraints(
        maxWidth: 500,
        minWidth: 200,
        maxHeight: context.width * .7,
        minHeight: 200,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tasks',
                style: context.textTheme.bodyLarge,
              ),
              CloseButton(
                style: ButtonStyle(
                  maximumSize: MaterialStateProperty.all(
                    const Size(40, 40),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    const Size(20, 20),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(0),
                  ),
                  iconSize: MaterialStateProperty.all(14.0),
                  backgroundColor: MaterialStateProperty.all(
                      context.customColors.alertContainer),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            color: context.customColors.monkBlue!,
            thickness: .2,
          ),
          // SEARCH INPUT
          if (searchType == null)
            SearchOptions(
              onOptionSelect: (String option) {
                if (option == 'my') {
                  final authState = ref.read(authProvider);
                  final session = authState.value!.session;
                  openThread(
                      context, session?.fullName ?? "", session?.userId ?? "");
                } else {
                  // openThread(context, 'Other Tasks', 'other');
                  setState(() {
                    isSearching = true;
                    searchType = option;
                  });
                }
              },
            )
          else ...[
            SelectUser(
              allUsers: allUsers,
              onClear: () {
                setState(() {
                  isSearching = false;
                  searchType = null;
                });
              },
              onUserSelected: (UserModel user) {
                openThread(context, user.name ?? "", user.id);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class SearchOptions extends StatelessWidget {
  const SearchOptions({super.key, required this.onOptionSelect});
  final Function(String option) onOptionSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () {
            onOptionSelect('my');
          },
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          minVerticalPadding: 0,
          title: RichText(
            text: TextSpan(
                text: 'My Tasks:',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(.9),
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: ' Click to search for tasks assigned to you',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(.5),
                      fontSize: 12,
                    ),
                  ),
                ]),
          ),
          hoverColor: context.colorScheme.primary.withOpacity(0.8),
          focusColor: context.colorScheme.onSurface,
        ),
        ListTile(
          onTap: () {
            onOptionSelect('other');
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          dense: true,
          title: RichText(
            text: TextSpan(
                text: 'Other Tasks:',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(.9),
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: ' Search for tasks assigned to other team members',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(.5),
                      fontSize: 12,
                    ),
                  ),
                ]),
          ),
          hoverColor: context.colorScheme.primary.withOpacity(0.8),
        ),
      ],
    );
  }
}

class SelectUser extends ConsumerStatefulWidget {
  const SelectUser({
    super.key,
    required this.onClear,
    required this.onUserSelected,
    required this.allUsers,
  });
  final VoidCallback? onClear;
  final ValueChanged<UserModel>? onUserSelected;
  final AsyncValue<List<UserModel>> allUsers;
  @override
  SelectUserState createState() => SelectUserState();
}

class SelectUserState extends ConsumerState<SelectUser> {
  UserModel? selectedUser;

  @override
  Widget build(BuildContext context) {
    return widget.allUsers.maybeWhen(
      orElse: () => Container(),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (state) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (state.isNotNullEmpty)
            DropdownButton<UserModel?>(
              value: selectedUser,
              hint: Text(
                'Select User to view their tasks',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(.9),
                  fontSize: 14,
                ),
              ),
              isExpanded: true,
              underline: Container(
                height: .5,
                color: context.customColors.sourceMonkBlue,
              ),
              dropdownColor: context.colorScheme.background.withOpacity(.95),
              onChanged: (UserModel? newValue) {
                setState(() {
                  selectedUser = newValue;
                });
              },
              items: state.map<DropdownMenuItem<UserModel>>((UserModel user) {
                return DropdownMenuItem<UserModel>(
                    value: user,
                    child: ListTile(
                      title: Text(
                        user.name ?? "N/A",
                      ),
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CacheImage(
                          path: user.picture!.startsWith('https')
                              ? user.picture!
                              : "https://api.dicebear.com/7.x/identicon/png?seed=${user.name ?? "UN"}",
                          width: 35,
                          height: 35,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ));
              }).toList(),
            ),
          const Padding(padding: EdgeInsets.all(16)),
          if (selectedUser != null)
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                OutlineIconButton(
                  label: 'Clear',
                  onPressed: () {
                    setState(() {
                      selectedUser = null;
                    });
                  },
                  horizontalPadding: 36,
                  verticalPadding: 16,
                ),
                const SizedBox(width: 8),
                OutlineIconButton(
                  label: 'View',
                  onPressed: () {
                    widget.onUserSelected!(selectedUser!);
                  },
                  horizontalPadding: 36,
                  verticalPadding: 16,
                  isFilled: true,
                )
              ],
            )
          else
            OutlineIconButton(
              label: 'Back',
              onPressed: widget.onClear,
              horizontalPadding: 36,
              verticalPadding: 16,
            ),
        ],
      ),
    );
  }
}
