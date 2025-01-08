import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  ThemeButton({super.key, required this.changeTheme});

  final Function changeTheme;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return IconButton(
        onPressed: () {
          changeTheme(isBright);
        },
        icon: isBright
            ? Icon(Icons.light_mode_outlined)
            : Icon(Icons.dark_mode_outlined));
  }
}
