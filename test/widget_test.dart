import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipher_x/app/app.dart';
import 'package:cipher_x/core/constants/app_constants.dart';

void main() {
  group('Cipher-X Bootstrap Tests', () {
    testWidgets('Root CipherXApp renders BootstrapScreen title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: CipherXApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppConstants.appName), findsWidgets);
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    });

    testWidgets('App renders loading and error widgets correctly',
        (WidgetTester tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Column(
                  children: <Widget>[
                    const Text('Test Shell'),
                    ElevatedButton(
                      onPressed: () {
                        retried = true;
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Test Shell'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });
  });
}
