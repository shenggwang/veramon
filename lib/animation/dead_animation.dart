import 'package:flutter/material.dart';

class DeadAnimation extends StatefulWidget {
  final Image image;

  const DeadAnimation({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DeadAnimation();
  }
}

class _DeadAnimation extends State<DeadAnimation> with TickerProviderStateMixin{

  AnimationController _deadAnimationController;
  Animation<double> _deadAnimation;

  @override
  void initState(){
    super.initState();
    this._deadAnimationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    this._deadAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(this._deadAnimationController);
    this._deadAnimationController.forward();
  }

  @override
  void dispose() {
    _deadAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dead(
      image: widget.image,
      animation: _deadAnimation,
    );
  }

}

class Dead extends AnimatedWidget {
  final Image image;
  const Dead(
      {Key key,
        this.image,
        Animation<double> animation,
      })
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    return Transform.scale(
      scale: animation.value,
      child: this.image,
    );
  }
}