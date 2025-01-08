import 'package:flutter/material.dart';

class CircleImageWidget extends StatelessWidget {
  const CircleImageWidget({
    super.key,
    required this.imageProvider,
    required this.radius,
  });

  final ImageProvider<Object>? imageProvider;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: CircleAvatar(
        radius: radius - 5,
        backgroundImage: imageProvider,
      ),
    );
  }
}
