import 'package:flutter_test/flutter_test.dart';
import 'package:lab07_demo/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab07App());
    // HomeScreen AppBar title
    expect(find.text('Lab 07 — Web Services & APIs'), findsOneWidget);
    // All three lesson tiles visible
    expect(find.text('Lesson 31 — ListView.builder'), findsOneWidget);
    expect(find.text('Lesson 32 — Debugging Null Crash'), findsOneWidget);
    expect(find.text('Lessons 33 & 34 — Fetching Posts via HTTP'), findsOneWidget);
  });
}
