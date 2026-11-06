import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Observes pointers without entering the arena used by image zoom and paging.
class PullDownToDismiss extends StatefulWidget {
  const PullDownToDismiss({super.key, required this.child, required this.canStart});

  final Widget child;
  final bool Function() canStart;

  @override
  State<PullDownToDismiss> createState() => _PullDownToDismissState();
}

class _PullDownToDismissState extends State<PullDownToDismiss> {
  final _pointers = <int>{};
  int? _candidate;
  Offset _distance = Offset.zero;
  bool _popping = false;

  void _cancel() {
    _candidate = null;
    _distance = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _pointers.add(event.pointer);
        if (_pointers.length != 1 ||
            event.kind != PointerDeviceKind.touch ||
            !widget.canStart() ||
            ModalRoute.of(context)?.isCurrent != true) {
          _cancel();
          return;
        }
        _candidate = event.pointer;
        _distance = Offset.zero;
      },
      onPointerMove: (event) {
        if (_candidate != event.pointer) return;
        _distance += event.delta;
        if (!widget.canStart() ||
            _distance.dy < -kTouchSlop ||
            (_distance.dx.abs() > kTouchSlop &&
                _distance.dx.abs() > _distance.dy)) {
          _cancel();
        }
      },
      onPointerUp: (event) async {
        _pointers.remove(event.pointer);
        final dismiss = _candidate == event.pointer &&
            _pointers.isEmpty &&
            _distance.dy >= 120 &&
            _distance.dy > _distance.dx.abs() * 2 &&
            widget.canStart() &&
            ModalRoute.of(context)?.isCurrent == true;
        _cancel();
        if (!dismiss || _popping) return;
        _popping = true;
        await Navigator.of(context).maybePop();
        if (mounted) _popping = false;
      },
      onPointerCancel: (event) {
        _pointers.remove(event.pointer);
        _cancel();
      },
      child: widget.child,
    );
  }
}
