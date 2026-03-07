import 'package:flutter_test/flutter_test.dart';
import 'package:lab05_demo/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab05App());
    expect(find.text('Age Calculator'), findsOneWidget);
  });
}
