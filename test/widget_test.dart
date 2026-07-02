import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_pak_app/main.dart';

void main() {
  testWidgets('App renders successfully and displays title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LaporPakApp());

    // Verify that our app displays 'Lapor Pak!'.
    expect(find.text('Lapor Pak!'), findsOneWidget);
  });
}
