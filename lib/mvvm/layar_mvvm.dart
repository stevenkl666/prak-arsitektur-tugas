import 'package:flutter/material.dart';
import '../data/repositori_tugas.dart';
import '../ui/panel_tugas.dart';
import 'tugas_view_model.dart';

class LayarMvvm extends StatefulWidget {
  const LayarMvvm({super.key});

  @override
  State<LayarMvvm> createState() => _LayarMvvmState();
}

class _LayarMvvmState extends State<LayarMvvm> {
  final _viewModel = TugasViewModel(RepositoriTugas());

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) => PanelTugas(
          judul: 'Daftar Tugas · MVVM',
          daftar: _viewModel.daftarTerlihat,
          total: _viewModel.total,
          jumlahSelesai: _viewModel.jumlahSelesai,
          galat: _viewModel.galat,
          filterAktif: _viewModel.hanyaBelumSelesai,
          onFilter: _viewModel.ubahFilter,
          onTambah: _viewModel.tambah,
          onUbahStatus: _viewModel.ubahStatus,
        ),
      );
}