import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prog2025_firtst/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construir la app
    await tester.pumpWidget(MyApp());

    // Verificar que el contador empieza en 0
    expect(find.text('Contador 0'), findsOneWidget);
    expect(find.text('Contador 1'), findsNothing);

    // Tap en el botón con ícono ads_click
    await tester.tap(find.byIcon(Icons.ads_click));
    await tester.pump();

    // Verificar que incrementó a 1
    expect(find.text('Contador 0'), findsNothing);
    expect(find.text('Contador 1'), findsOneWidget);
  });
}
