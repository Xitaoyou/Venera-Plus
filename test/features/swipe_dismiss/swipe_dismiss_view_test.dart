import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:venera_plus/features/swipe_dismiss/swipe_dismiss_view.dart';

void main() {
  testWidgets('only a single downward touch dismisses an enabled image', (
    tester,
  ) async {
    var count = 0;
    var allowed = true;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeDismissView(
            canStart: () => allowed,
            onDismiss: () => count++,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.dragFrom(const Offset(200, 200), const Offset(0, 160));
    await tester.pumpAndSettle();
    expect(count, 1);
    allowed = false;
    await tester.dragFrom(const Offset(200, 200), const Offset(0, 160));
    await tester.pumpAndSettle();
    expect(count, 1);
    allowed = true;
    await tester.dragFrom(const Offset(200, 200), const Offset(160, 130));
    await tester.pumpAndSettle();
    expect(count, 1);
    final first = await tester.startGesture(
      const Offset(200, 200),
      pointer: 10,
    );
    final second = await tester.startGesture(
      const Offset(220, 200),
      pointer: 11,
    );
    await first.moveBy(const Offset(0, 160));
    await second.up();
    await first.up();
    await tester.pumpAndSettle();
    expect(count, 1);
    final cancelled = await tester.startGesture(
      const Offset(200, 200),
      pointer: 12,
    );
    await cancelled.moveBy(const Offset(0, 160));
    await cancelled.cancel();
    await tester.pumpAndSettle();
    expect(count, 1);
  });
}
