import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/chat/presentation/pages/messages_page.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/pages/candidates_page.dart';
import 'package:raqamli_sovchi/features/saved/presentation/pages/saved_page.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(390, 900);
    view.devicePixelRatio = 1;
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('candidate tab renders mock grid', (tester) async {
    await tester.pumpWidget(const _LocalizedTestApp(child: CandidatesPage()));

    expect(find.text('Nomzodlar'), findsOneWidget);
    expect(find.text('Moslik foizi yopiq'), findsOneWidget);
    expect(find.text('Soʻrovnomani boshlash'), findsOneWidget);
    expect(find.text('Mohira R., 23'), findsWidgets);
    expect(find.text('Maxfiy rasm'), findsWidgets);
    expect(find.text('moslik yopiq'), findsWidgets);
  });

  testWidgets('messages tab renders mock threads', (tester) async {
    await tester.pumpWidget(const _LocalizedTestApp(child: MessagesPage()));

    expect(find.text('Xabarlar'), findsOneWidget);
    expect(find.text('Suhbatlar'), findsOneWidget);
    expect(find.text('Vaqtingiz boʻlsa tanishsak.'), findsOneWidget);
  });

  testWidgets('saved tab renders saved grid and upsell', (tester) async {
    await tester.pumpWidget(const _LocalizedTestApp(child: SavedPage()));

    expect(find.text('Saqlangan'), findsOneWidget);
    expect(find.text('7 / 10 saqlangan'), findsOneWidget);
    expect(find.text('Yana 3 ta joy qoldi'), findsOneWidget);
  });
}

final class _LocalizedTestApp extends StatelessWidget {
  const _LocalizedTestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }
}
