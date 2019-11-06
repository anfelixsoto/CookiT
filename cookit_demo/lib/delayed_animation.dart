import 'dart:async';
import 'package:flutter/material.dart';

class DelayedAnimation extends StatefulWidget{
  final Widget child;
  final int delay;

  DelayedAnimation({@required this.child, this.delay});

  @override
  _DelayedAnimationState createState()=> _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
  with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animOffest;

  @override
  void initState(){
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 800));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _controller);
    _animOffest =
        Tween<Offset>(begin: const Offset(0.0, .35), end: Offset.zero).animate(curve);
    if(widget.delay == null){
      _controller.forward();
    }else{
      Timer(Duration(microseconds: widget.delay), (){
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return FadeTransition(
      child: SlideTransition(
        position: _animOffest,
        child: widget.child,
      ),
      opacity: _controller,
    );
  }
}