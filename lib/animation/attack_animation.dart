import 'package:flutter/material.dart';

class AttackAnimation extends StatefulWidget {
  final bool enemy;
  final Image image;
  final idle;
  final defend;

  const AttackAnimation({
    Key key,
    this.enemy,
    this.image,
    this.idle,
    this.defend,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AttackAnimation();
  }
}

class _AttackAnimation extends State<AttackAnimation> with TickerProviderStateMixin{

  AnimationController _attackAnimationController;
  Animation<double> _attackAnimation;

  @override
  void initState(){
    super.initState();
    this._attackAnimationController =
        AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    this._attackAnimation = Tween<double>(begin: 0.0, end: 50.0).animate(this._attackAnimationController);
    this._attackAnimation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        widget.defend();
        widget.idle();
      }
    });
    this._attackAnimationController.forward();
  }

  @override
  void dispose() {
    _attackAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Attack(
      enemy: widget.enemy,
      image: widget.image,
      animation: _attackAnimation,
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
      offset: enemy ? Offset(-(animation.value), (animation.value)/2) : Offset((animation.value), -(animation.value)/2),
      child: this.image,
    );
  }
}