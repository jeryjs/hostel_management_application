import 'package:flutter/material.dart';

/// A custom clipper that creates a circular reveal effect.
///
/// This clipper is used to create a circular reveal effect during page transitions.
/// It takes a center point and a radius as parameters to define the circular shape.
/// The [getClip] method returns a [Path] that represents the circular shape.
/// The [shouldReclip] method always returns true to ensure that the clipper is always updated.
class CircleRevealClipper extends CustomClipper<Path> {
  // ignore: prefer_typing_uninitialized_variables
  final center, radius;

  CircleRevealClipper({this.center, this.radius});

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
        radius: radius, center: center
      )
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

/// Creates a page route with a circular reveal transition effect.
///
/// This function returns a [PageRouteBuilder] that can be used to create a page route
/// with a circular reveal transition effect. It takes a [screen] widget as a parameter
/// and returns a page route that animates the transition using the circular reveal effect.
/// The transition duration is set to 500 milliseconds.
/// The [transitionsBuilder] method uses the [CircleRevealClipper] to create the circular
/// reveal effect based on the animation and screen size.
PageRouteBuilder transitionPageRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionDuration: const Duration(milliseconds: 500),
    // reverseTransitionDuration: const Duration(milliseconds: 2000),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var screenSize = MediaQuery.of(context).size;
      return ClipPath(
        clipper: CircleRevealClipper(
          radius: animation.drive(Tween(begin: 0.0, end: screenSize.height * 1.5)).value,
          center: Offset(screenSize.width/1.1, screenSize.height / 2),
        ),
        child: child,
      );
    },
  );
}