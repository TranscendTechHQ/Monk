import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/theme.dart';

class DismissButton extends StatelessWidget {
  const DismissButton(
      {super.key, required this.onPressed, required this.tooltip});
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.customColors.sourceAlert,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.clear,
            size: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
