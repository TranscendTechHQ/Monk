import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/widgets/user-mention/users.provider.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/cache_image.dart';
import 'package:frontend/ui/widgets/dismiss_button.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';
import 'package:openapi/openapi.dart';

class TodoAssignView extends ConsumerStatefulWidget {
  const TodoAssignView({super.key});

  @override
  TodoAssignViewState createState() => TodoAssignViewState();
}

class TodoAssignViewState extends ConsumerState<TodoAssignView> {
  UserModel? selectedUser;
  @override
  void initState() {
    ref.read(usersProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var allUsers = ref.watch(usersProvider);
    return allUsers.maybeWhen(
      orElse: () => Container(),
      data: (state) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assign the Task',
                style: context.textTheme.titleMedium,
              ),
              DismissButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: 'Close',
              )
            ],
          ),
          Divider(
            color: context.customColors.monkBlue!.withOpacity(.5),
            thickness: .5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              'Assigned to',
              style: TextStyle(
                  fontSize: 12, color: context.customColors.monkBlue!),
            ),
          ),
          if (state.isNotNullEmpty)
            DropdownButton<UserModel?>(
              value: selectedUser,
              hint: const Text('Select User'),
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
          const Padding(padding: EdgeInsets.all(8)),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              OutlineIconButton(
                label: 'Cancel',
                onPressed: () {
                  Navigator.pop(context);
                },
                horizontalPadding: 36,
                verticalPadding: 16,
              ),
              OutlineIconButton(
                label: 'Save',
                onPressed: () {
                  Navigator.pop(context, selectedUser);
                },
                horizontalPadding: 36,
                verticalPadding: 16,
                isFilled: true,
              )
            ],
          )
        ],
      ),
    );
  }
}
