import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/main.dart';

void main() {
  testWidgets('App smoke test — renders without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(const HabitTrackerApp());
    await tester.pump();
    // Simply verify the app renders without throwing.
    expect(find.byType(HabitTrackerApp), findsOneWidget);
  });
}
