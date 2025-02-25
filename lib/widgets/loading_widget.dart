import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final String animationPath;

  const LoadingWidget({
    this.animationPath = 'assets/icons/mano.json',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // 🔥 Hace el fondo invisible
      child: Center(
        child: Lottie.asset(animationPath, width: 150, height: 150),
      ),
    );
  }
}
