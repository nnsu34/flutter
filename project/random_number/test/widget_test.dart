import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:number/screen/home_screen.dart'; // main.dart를 임포트하지 않아도 됩니다.

void main() {
  testWidgets('HomeScreen widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify that certain texts or widgets are present in the screen.
    expect(find.text('Random Number Generator'), findsOneWidget);

    // Verify that the numbers displayed are correct or as expected.
    expect(find.text('No Numbers Selected'), findsOneWidget);

    // You can add more interactions like tapping or scrolling here if needed.
    // For example:
    // await tester.tap(find.text('Pick Numbers'));
    // await tester.pump();
  });
}
