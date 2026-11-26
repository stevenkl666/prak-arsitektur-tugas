# LAPORAN Praktikum Mandiri: MVC, MVVM, dan Pengujian Flutter

## Identitas

- Nama: STEPHANUS KURNIA LESMANA
- NIM: 362558302075
- Kelas: 2E
- Mata kuliah: Pemrograman Perangkat Bergerak, TRPL Poliwangi
- Tautan repository dan commit: https://github.com/stevenkl666/prak-arsitektur-tugas

## Cara Menjalankan

```
cd prak_arsitektur_tugas
flutter pub get
flutter run -d chrome
```

Menjalankan pengujian dan analisis kode:

```
flutter analyze
flutter test
flutter test test/filter_test.dart
```

Berkas test: `test/smoke_test.dart` (bawaan starter), `test/logika_test.dart`, `test/layar_test.dart`, dan `test/filter_test.dart`.

## Ringkasan Fitur Filter

Satu `FilterChip` berlabel **Belum selesai** (`ValueKey('filter-belum-selesai')`) ditambahkan di `lib/ui/panel_tugas.dart`, dipakai bersama oleh versi MVC dan MVVM. Semua tugas tetap disimpan di `RepositoriTugas`. Pilihan filter disimpan sebagai `bool` bernilai awal `false` (`_hanyaBelumSelesai`). Daftar yang tampil dihitung lewat getter `daftarTerlihat`. Ringkasan (`jumlahSelesai` dari `total`) tetap dihitung dari seluruh tugas, sehingga saat filter aktif ringkasan tetap misalnya `1 dari 2 selesai`.

## Tabel Perbandingan

### 1. Ketika filter diketuk, class mana yang menerima aksi dan menyimpan pilihan?

| Versi | Class                                               | Metode                                                                                       | Penyimpan pilihan                               |
| ----- | --------------------------------------------------- | -------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| MVC   | `PengendaliTugas` (`lib/mvc/pengendali_tugas.dart`) | `ubahFilter(bool nilai)`, dipanggil dari `_ubahFilter` di `LayarMvc`                         | field `_hanyaBelumSelesai` di `PengendaliTugas` |
| MVVM  | `TugasViewModel` (`lib/mvvm/tugas_view_model.dart`) | `ubahFilter(bool nilai)`, dihubungkan lewat `onFilter: _viewModel.ubahFilter` di `LayarMvvm` | field `_hanyaBelumSelesai` di `TugasViewModel`  |

Alur MVC: `FilterChip.onSelected` memanggil `_ubahFilter` di `_LayarMvcState`, lalu `PengendaliTugas.ubahFilter` menyimpan pilihan dan `setState()` memicu rebuild. Alur MVVM: `FilterChip.onSelected` memanggil `TugasViewModel.ubahFilter`, yang menyimpan pilihan dan memanggil `notifyListeners()`.

### 2. Apa yang memicu rebuild? Apa akibatnya jika pemicu itu dihapus?

| Versi | Pemicu rebuild                                                                           | Percobaan                                                                                                      | Hasil                                                                                                                         |
| ----- | ---------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| MVC   | `setState(() => _pengendali.ubahFilter(nilai))` di `_LayarMvcState._ubahFilter`          | Menghapus sementara `setState` di `_ubahFilter`, lalu menjalankan `flutter test test/filter_test.dart`         | [ISI HASIL: test MVC gagal, `Rancang UI Flutter` masih tampil setelah filter diaktifkan. Tempel potongan keluaran terminal.]  |
| MVVM  | `notifyListeners()` di `TugasViewModel.ubahFilter`, yang didengarkan `ListenableBuilder` | Menghapus sementara `notifyListeners()` di `ubahFilter`, lalu menjalankan `flutter test test/filter_test.dart` | [ISI HASIL: test MVVM gagal, `Rancang UI Flutter` masih tampil setelah filter diaktifkan. Tempel potongan keluaran terminal.] |

Penjelasan: pada kedua versi, `_hanyaBelumSelesai` tetap berubah di Controller atau ViewModel, tetapi UI tidak dibangun ulang sehingga daftar yang terlihat tidak ikut berubah. Setelah baris dikembalikan, kedua test lulus kembali

C:\ppb\prak_arsitektur_tugas>flutter test
00:10 +7: All tests passed!

### 3. Kapan memilih masing-masing pola?

**MVC**

- Skenario yang cocok: layar sederhana dengan sedikit aksi, misalnya form satu layar dengan tambah dan centang tugas.
- Kelebihan: alur aksi mudah ditelusuri dalam satu file layar, karena callback dan `setState()` berada di `LayarMvc`.
- Biaya atau risiko: setiap aksi yang memengaruhi tampilan harus diikuti `setState()`. Pada kode filter, jika `setState()` di `_ubahFilter` terlupa, pilihan filter berubah di Controller tetapi layar tidak berubah (terbukti pada percobaan di atas).

**MVVM**

- Skenario yang cocok: layar dengan daftar yang bisa difilter dan ringkasan, karena daftar yang tampil berbeda dari data lengkap. `TugasViewModel` menyediakan `daftarTerlihat`, `total`, dan `jumlahSelesai` sebagai sumber UI state.
- Kelebihan: logika dan notifikasi dapat diuji tanpa membangun layar, misalnya `test/logika_test.dart` mencatat urutan notifikasi `[0, 0, 1]`.
- Biaya atau risiko: ViewModel harus mengirim `notifyListeners()` pada setiap perubahan state dan lifecycle-nya harus dikelola (`dispose()` di `_LayarMvvmState`). Jika `notifyListeners()` di `ubahFilter` terlupa, layar tidak diperbarui.

## Bukti

- `bukti/mvc_filter_mati.png`
- `bukti/mvc_filter_aktif.png`
- `bukti/mvvm_filter_mati.png`
- `bukti/mvvm_filter_aktif.png`

Setiap gambar memakai dua tugas yang sama dan ringkasan `1 dari 2 selesai`.

## Keluaran Terminal

Setelah semua kode dipulihkan:

```
C:\ppb\prak_arsitektur_tugas>flutter analyze
Analyzing prak_arsitektur_tugas...
No issues found! (ran in 8.8s)
```

```
C:\ppb\prak_arsitektur_tugas>flutter test
00:10 +7: All tests passed!
```

Potongan kegagalan saat pemicu rebuild dihapus sementara:

```
00:07 +0: MVC: filter Belum selesai
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════
The following TestFailure was thrown running a test:
Expected: no matching candidates
  Actual: _TextWidgetFinder:<Found 1 widget with text "Rancang UI Flutter": [
            Text("Rancang UI Flutter", ...),
          ]>
   Which: means one was found but none were expected
...
The test description was:
  MVC: filter Belum selesai
══════════════════════════════════════════════════════════════════
00:07 +0 -1: MVC: filter Belum selesai [E]
  Test failed. See exception logs above.
```

```
00:08 +1: MVVM: filter Belum selesai
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════
The following TestFailure was thrown running a test:
Expected: no matching candidates
  Actual: _TextWidgetFinder:<Found 1 widget with text "Rancang UI Flutter": [
            Text("Rancang UI Flutter", ...),
          ]>
   Which: means one was found but none were expected
...
The test description was:
  MVVM: filter Belum selesai
══════════════════════════════════════════════════════════════════
00:08 +1 -1: MVVM: filter Belum selesai [E]
  Test failed. See exception logs above.
```
