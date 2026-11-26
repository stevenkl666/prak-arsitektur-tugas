import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prak_arsitektur_tugas/main.dart';

void main() {
  for (final mode in ['MVC', 'MVVM']) {
    testWidgets('$mode: filter Belum selesai', (tester) async {
      await tester.pumpWidget(const AplikasiTugas());
      await tester.tap(find.text('Buka $mode'));
      await tester.pumpAndSettle();

      final input = find.byKey(const ValueKey('judul-tugas'));
      final chip = find.byKey(const ValueKey('filter-belum-selesai'));

      for (final judul in ['Rancang UI Flutter', 'Catat hasil pengujian']) {
        await tester.enterText(input, judul);
        await tester.tap(find.text('Tambah tugas'));
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();
      expect(find.text('1 dari 2 selesai'), findsOneWidget);

      await tester.tap(chip);
      await tester.pumpAndSettle();
      expect(find.text('Rancang UI Flutter'), findsNothing);
      expect(find.text('Catat hasil pengujian'), findsOneWidget);
      expect(find.text('1 dari 2 selesai'), findsOneWidget);

    
      await tester.tap(chip);
      await tester.pumpAndSettle();
      expect(find.text('Rancang UI Flutter'), findsOneWidget);
      expect(find.text('Catat hasil pengujian'), findsOneWidget);
      expect(
        tester
            .widget<CheckboxListTile>(find.byType(CheckboxListTile).first)
            .value,
        isTrue,
      );

      await tester.tap(chip);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();
      expect(find.text('Tidak ada tugas yang belum selesai.'), findsOneWidget);
      expect(find.text('2 dari 2 selesai'), findsOneWidget);
    });
  }
}