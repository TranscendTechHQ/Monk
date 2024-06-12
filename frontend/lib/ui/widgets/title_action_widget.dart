import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/theme.dart';

class TileActionWidget extends StatelessWidget {
  const TileActionWidget({
    super.key,
    this.onDelete,
    this.onCustomIconPressed,
    this.icon,
    this.list = const [Choice(topic: "Delete", icon: Icons.delete)],
    this.menuKey,
    this.iconColor,
    this.tooltip,
  });
  final Widget? icon;
  final String? tooltip;
  final Color? iconColor;
  final Function? onDelete;
  final Function? onCustomIconPressed;
  final List<Choice>? list;
  final GlobalKey? menuKey;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
      key: menuKey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: context.theme.dividerColor,
          width: .3,
        ),
      ),
      onSelected: (action) {
        if (action.onPressed != null) {
          action.onPressed!.call();
        } else {
          switch (action.topic) {
            case "Delete":
              if (onDelete != null) onDelete!.call();
              break;
            default:
              if (onCustomIconPressed != null) onCustomIconPressed!.call();
          }
        }
      },
      padding: EdgeInsets.zero,
      color: context.surfaceColor,
      position: PopupMenuPosition.under,
      tooltip: tooltip,
      icon: icon ??
          Icon(
            Icons.more_vert,
            color: context.customColors.monkBlue,
            size: 20,
          ),
      itemBuilder: (BuildContext context) {
        return list!.map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Row(
              children: [
                Icon(
                  choice.icon,
                  size: 20,
                  color: iconColor ?? context.theme.iconTheme.color,
                ).pR(8),
                Text(
                  choice.topic,
                  // style: choice.style ?? TextStyles.bodyText15(context),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

class Choice {
  const Choice({
    required this.topic,
    this.icon,
    this.onPressed,
    this.style,
  });

  final IconData? icon;
  final String topic;
  final TextStyle? style;
  final VoidCallback? onPressed;
}
