import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/main.dart';

void main() {
  testWidgets('shows role selection screen', (tester) async {
    await tester.pumpWidget(const TransportApp());
    await tester.pump();

    expect(find.text('ESSELAM'), findsOneWidget);
    expect(find.text('voyageur'), findsOneWidget);
    expect(find.text('Chauffeur'), findsOneWidget);
  });
}
