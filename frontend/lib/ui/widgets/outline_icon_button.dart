import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/theme.dart';

class OutlineIconButton extends StatelessWidget {
  const OutlineIconButton({
    super.key,
    this.icon,
    required this.label,
    this.svgPath,
    this.onPressed,
    this.iconSize = 24,
    this.wrapped = true,
    this.verticalPadding = 14,
    this.horizontalPadding = 10,
    this.isFilled = false,
    this.borderColor = monkBlue700,
  });
  final IconData? icon;
  final String label;
  final String? svgPath;
  final VoidCallback? onPressed;
  final double iconSize;
  final bool wrapped;
  final double verticalPadding;
  final double horizontalPadding;
  final bool isFilled;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          isFilled ? monkBlue700 : context.theme.cardColor.withOpacity(.3),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: borderColor ?? monkBlue700,
              width: 1,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: wrapped ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, color: monkBlue700),
          if (svgPath != null)
            SvgPicture.asset(
              'assets/svg/$svgPath',
              color: monkBlue700,
              height: iconSize,
              width: iconSize,
            ),
          if (icon != null || svgPath != null) const SizedBox(width: 8),
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isFilled ? Colors.white : monkBlue700,
            ),
          )
        ],
      ),
    );
  }
}
