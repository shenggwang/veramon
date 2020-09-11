import 'package:flutter/material.dart';

class DefendAnimation extends StatefulWidget {
  final bool enemy;
  final Image image;
  final idle;

  const DefendAnimation({
    Key key,
    this.enemy,
    this.image,
    this.idle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DefendAnimation();
  }
}

class _DefendAnimation extends State<DefendAnimation> with TickerProviderStateMixin{

  AnimationController _defendAnimationController;
  Animation<double> _defendAnimation;

  @override
  void initState(){
    super.initState();
    this._defendAnimationController =
        AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    this._defendAnimation = Tween<double>(begin: 0.0, end: 50.0).animate(this._defendAnimationController);
    this._defendAnimation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        widget.idle();
      }
    });
    this._defendAnimationController.forward();
  }

  @override
  void dispose() {
    _defendAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Attack(
      enemy: widget.enemy,
      image: widget.image,
      animation: _defendAnimation,
    );
  }
}

class Attack extends AnimatedWidget {
  final Image image;
  final bool enemy;
  const Attack(
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
      offset: enemy ? Offset((animation.value), -(animation.value)/2) : Offset(-(animation.value), (animation.value)/2),
      child: this.image,
    );
  }
}