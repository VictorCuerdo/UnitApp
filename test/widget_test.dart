import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unitapp/main.dart';

void main() {
  testWidgets('Widget Test', (WidgetTester tester) async {
    // Build your app and trigger a frame.
    await tester.pumpWidget(UnitApp(analytics: FirebaseAnalytics.instance));

    // Add your test logic here.
    // For example, you can find widgets by their key and interact with them.

    // Verify the expected results of your test.
    // For example, you can check if a widget is displayed correctly.

    // You can also use the `expect` function to assert the results.
    // For example, you can check if a widget has a specific text.

    // Remember to call `pumpAndSettle` to ensure all animations have completed.
    await tester.pumpAndSettle();
  });
}
