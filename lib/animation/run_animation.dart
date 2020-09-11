import 'package:flutter/material.dart';

class RunAnimation extends StatefulWidget {
  final Image image;

  const RunAnimation({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RunAnimation();
  }
}

class _RunAnimation extends State<RunAnimation> with SingleTickerProviderStateMixin {

  AnimationController _runAnimationController;
  Animation<double> _runAnimation;

  @override
  void initState() {
    super.initState();
    this._runAnimationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    this._runAnimation = Tween<double>(begin: 0.0, end: -150.0).animate(
        this._runAnimationController);
    this._runAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
      }
    });
    this._runAnimationController.forward();
  }

  @override
  void dispose() {
    _runAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Run(
      image: widget.image,
      animation: _runAnimation,
    );
  }
}

class Run extends AnimatedWidget {
  final Image image;
  const Run(
      {Key key,
        this.image,
        Animation<double> animation,
      })
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    return Transform.translate(
      offset: Offset(animation.value, 0),
      child: image,
    );
  }
}