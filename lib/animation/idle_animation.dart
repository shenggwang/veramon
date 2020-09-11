import 'package:flutter/material.dart';


class IdleAnimation extends StatefulWidget {
  final bool enemy;
  final Image image;

  const IdleAnimation({
    Key key,
    this.enemy,
    this.image,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IdleAnimation();
  }
}

class _IdleAnimation extends State<IdleAnimation> with TickerProviderStateMixin{

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState(){
    super.initState();
    this._animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    this._animation = Tween<double>(begin: -5, end: 5).animate(this._animationController);
    this._animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        this._animationController.reverse();
      } else if(status == AnimationStatus.dismissed){
        this._animationController.forward();
      }
    });
    this._animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Idle(
      enemy: widget.enemy,
      image: widget.image,
      animation: _animation,
    );
  }

}

class Idle extends AnimatedWidget {
  final Image image;
  final bool enemy;
  const Idle(
      {Key key,
        this.enemy,
        this.image,
        Animation<double> animation,
      })
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    return Transform.translate(
      offset: Offset(enemy?-(animation.value):(animation.value), 0),
      child: image,
    );
  }
}