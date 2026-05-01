import 'package:flutter/material.dart';
import 'dart:math' as math;

enum RadialDirection {
  whole,
  firstQuadrant,
  secondQuadrant,
  thirdQuadrant,
  fourthQuadrant,
  top,
  down,
  right,
  left,
}

class RadialMenu extends StatefulWidget {

  final double radialMenuRadius;
  final Widget radialMenuButtonActivated;
  final Widget radialMenuButtonDeactivated;
  final List<Widget> radialMenuItems;
  final Color radialMenuButtonActivatedColor;
  final Color radialMenuButtonDeactivatedColor;
  final int distance;
  final RadialDirection direction;
  final double areaWidth;
  final double areaHeight;
  final Color backgroundColor;
  final bool rotateItems;
  final int milliseconds;
  final Alignment alignment;

  const RadialMenu({
    required this.radialMenuButtonActivated,
    required this.radialMenuButtonDeactivated,
    required this.radialMenuItems,
    this.backgroundColor = Colors.transparent,
    this.alignment = Alignment.centerRight,
    this.rotateItems = false,
    this.distance = 35,
    this.milliseconds = 300,
    this.radialMenuRadius = 23,
    this.areaWidth = 100,
    this.areaHeight = 100,
    this.direction = RadialDirection.left,
    this.radialMenuButtonActivatedColor = Colors.red,
    this.radialMenuButtonDeactivatedColor = Colors.blue,
    super.key,
  }):assert(radialMenuItems.length > 0, 'radialMenuItems cannot be empty'),
     assert(radialMenuRadius > 0, 'radialMenuRadius must be > 0'),
     assert(distance >= 0, 'distance must be >= 0'),
     assert(milliseconds > 0, 'milliseconds must be > 0');

  @override
  State<RadialMenu> createState() => _RadialMenuState();

}

class _RadialMenuState extends State<RadialMenu> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double> _anim;
  late List<Offset> _offsets;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.milliseconds));
    _anim = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _offsets = _buildOffsets();
  }

  List<Offset> _buildOffsets() {
    final r = widget.radialMenuRadius + widget.distance;
    final count = widget.radialMenuItems.length;
    return List.generate(count, (i) {
      final step = widget.direction == RadialDirection.whole
        ? (2 * math.pi / count)
        : (math.pi / (count + 1));
      final base = {
        RadialDirection.firstQuadrant: 1.5 * math.pi,
        RadialDirection.secondQuadrant: math.pi,
        RadialDirection.thirdQuadrant: 0.5 * math.pi,
        RadialDirection.fourthQuadrant: 0.0,
        RadialDirection.top: math.pi,
        RadialDirection.down: 0.0,
        RadialDirection.right: 1.5 * math.pi,
        RadialDirection.left: 0.5 * math.pi,
        RadialDirection.whole: 0.0,
      }[widget.direction]!;
      final angle = base + step * (widget.direction == RadialDirection.whole ? i : i + 1);
      return Offset(r * math.cos(angle), r * math.sin(angle));
    });
  }

  void _toggle()=>setState((){
    _active = !_active;
    _active ? _controller.forward() : _controller.reverse();
  });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RadialMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.milliseconds != widget.milliseconds) {
      _controller.duration = Duration(milliseconds: widget.milliseconds);
    }
    if (oldWidget.direction != widget.direction ||
        oldWidget.radialMenuItems.length != widget.radialMenuItems.length ||
        oldWidget.distance != widget.distance ||
        oldWidget.radialMenuRadius != widget.radialMenuRadius) {
      _offsets = _buildOffsets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.areaWidth,
      height: widget.areaHeight,
      child: Stack(
        children: [
          for (int i = 0; i < widget.radialMenuItems.length; i++)
            Align(
              alignment: widget.alignment,
              child: AnimatedBuilder(
                animation: _anim,
                child: widget.radialMenuItems[i],
                builder: (_, child) {
                  final o = _offsets[i] * _anim.value;
                  return Transform.translate(
                    offset: o,
                    child: widget.rotateItems
                      ? Transform.rotate(angle: 2 * math.pi * _anim.value, child: child)
                      : child,
                  );
                },
              ),
            ),
          Align(
            alignment: widget.alignment,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
              child: GestureDetector(
                key: ValueKey(_active),
                onTap: _toggle,
                child: Container(
                  width: widget.radialMenuRadius * 2,
                  height: widget.radialMenuRadius * 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radialMenuRadius),
                    color: _active
                      ? widget.radialMenuButtonActivatedColor
                      : widget.radialMenuButtonDeactivatedColor,
                  ),
                  child: _active
                    ? widget.radialMenuButtonActivated
                    : widget.radialMenuButtonDeactivated,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}