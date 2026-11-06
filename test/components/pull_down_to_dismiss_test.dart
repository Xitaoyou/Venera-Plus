import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:venera_plus/components/pull_down_to_dismiss.dart';
void main() {
  Future<void> open(WidgetTester tester, {bool enabled = true}) async {
    await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => TextButton(
      onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => Scaffold(body: PullDownToDismiss(canStart: () => enabled, child: const SizedBox.expand(child: Text('image')))))),
      child: const Text('open'),
    ))));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }
  testWidgets('downward touch returns through Navigator', (tester) async {
    await open(tester);
    await tester.dragFrom(const Offset(300, 200), const Offset(0, 180));
    await tester.pumpAndSettle();
    expect(find.text('image'), findsNothing);
  });
  testWidgets('disabled mode retains page', (tester) async {
    await open(tester, enabled: false);
    await tester.dragFrom(const Offset(300, 200), const Offset(0, 180));
    await tester.pumpAndSettle();
    expect(find.text('image'), findsOneWidget);
  });
  testWidgets('horizontal and upward movements retain page', (tester) async {
    await open(tester);
    await tester.dragFrom(const Offset(300, 200), const Offset(180, 140));
    await tester.dragFrom(const Offset(300, 300), const Offset(0, -180));
    await tester.pumpAndSettle();
    expect(find.text('image'), findsOneWidget);
  });
}
