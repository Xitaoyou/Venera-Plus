import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Passive pointer observer: does not override PhotoView gesture arena.
class SwipeDismissView extends StatefulWidget {
  const SwipeDismissView({
    super.key,
    required this.child,
    required this.onDismiss,
    required this.canStart,
    this.enabled = true,
  });
  final Widget child;
  final VoidCallback onDismiss;
  final bool Function() canStart;
  final bool enabled;
  @override
  State<SwipeDismissView> createState() => _SwipeDismissViewState();
}

class _SwipeDismissViewState extends State<SwipeDismissView> {
  final Set<int> _active = {};
  int? _tracked;
  Offset _distance = Offset.zero;
  double _offset = 0;
  bool _blocked = false;
  void _reset() {
    if (_offset != 0 && mounted) setState(() => _offset = 0);
  }

  @override
  void didUpdateWidget(covariant SwipeDismissView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled && !widget.enabled) {
      _tracked = null;
      _blocked = true;
      _reset();
    }
  }

  void _down(PointerDownEvent e) {
    _active.add(e.pointer);
    if (_active.length != 1) {
      _tracked = null;
      _blocked = true;
      _reset();
      return;
    }
    if (_blocked ||
        e.kind != PointerDeviceKind.touch ||
        !widget.enabled ||
        !widget.canStart() ||
        ModalRoute.of(context)?.isCurrent != true)
      return;
    _tracked = e.pointer;
    _distance = Offset.zero;
  }

  void _move(PointerMoveEvent e) {
    if (_tracked != e.pointer || _blocked) return;
    if (!widget.enabled || !widget.canStart()) {
      _tracked = null;
      _blocked = true;
      _reset();
      return;
    }
    _distance += e.delta;
    if (_distance.dy < -16 ||
        (_distance.dx.abs() > 24 && _distance.dx.abs() > _distance.dy.abs())) {
      _tracked = null;
      _blocked = true;
      _reset();
      return;
    }
    if (_distance.dy > 12 && _distance.dy > _distance.dx.abs() * 1.5) {
      setState(() => _offset = _distance.dy.clamp(0.0, 240.0));
    }
  }

  void _finish(PointerEvent e, {bool cancelled = false}) {
    final dismiss =
        !cancelled &&
        _tracked == e.pointer &&
        _active.length == 1 &&
        !_blocked &&
        widget.enabled &&
        widget.canStart() &&
        ModalRoute.of(context)?.isCurrent == true &&
        _distance.dy >= 120 &&
        _distance.dy > _distance.dx.abs() * 1.5;
    _active.remove(e.pointer);
    if (_active.isEmpty) {
      _tracked = null;
      _blocked = false;
      _distance = Offset.zero;
      _reset();
    }
    if (dismiss && mounted) widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: _down,
    onPointerMove: _move,
    onPointerUp: _finish,
    onPointerCancel: (e) => _finish(e, cancelled: true),
    child: AnimatedContainer(
      duration: _tracked != null
          ? Duration.zero
          : const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, _offset, 0),
      child: widget.child,
    ),
  );
}
