import 'package:flutter_test/flutter_test.dart';
import 'package:venera_plus/features/swipe_dismiss/swipe_dismiss_policy.dart';
void main() {
  bool allow({bool ios=true,bool enabled=true,bool vertical=false,bool collect=false,bool zoom=false,bool busy=false}) =>
    canDismissReaderBySwipe(isIOS: ios, enabled: enabled, verticalReading: vertical,
      pullToCollect: collect, zoomed: zoom, busy: busy);
  test('normal reading returns', () => expect(allow(), isTrue));
  test('conflicts suppress only while active', () {
    expect(allow(collect:true), isFalse);
    expect(allow(vertical:true), isFalse);
    expect(allow(zoom:true), isFalse);
    expect(allow(busy:true), isFalse);
    expect(allow(enabled:false), isFalse);
    expect(allow(ios:false), isFalse);
    expect(allow(), isTrue);
  });
}
