import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/ui/widgets/app_bottom_nav_bar.dart';
import 'package:raqamli_sovchi/gen/assets.gen.dart';

void main() {
  testWidgets('renders labels and reports selected tab index', (tester) async {
    var selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              bottomNavigationBar: AppBottomNavBar(
                currentIndex: selectedIndex,
                onItemSelected: (index) {
                  setState(() => selectedIndex = index);
                },
                items: [
                  AppBottomNavItem(
                    label: 'Nomzodlar',
                    icon: Assets.icons.icCandidatesBtv,
                  ),
                  AppBottomNavItem(
                    label: 'Xabarlar',
                    icon: Assets.icons.icMessagesBtv,
                  ),
                  AppBottomNavItem(
                    label: 'Xizmatlar',
                    icon: Assets.icons.icServicesBtv,
                  ),
                  AppBottomNavItem(
                    label: 'Saqlangan',
                    icon: Assets.icons.icPreservedBtv,
                  ),
                  AppBottomNavItem(
                    label: 'Profil',
                    icon: Assets.icons.icProfileBtv,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Nomzodlar'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pump();

    expect(selectedIndex, 4);
  });
}
