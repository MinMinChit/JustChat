import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 6,
      color: Color(0xff02A2FA),
      backgroundColor: Color(0xff0CD3D6),
    );
  }
}
