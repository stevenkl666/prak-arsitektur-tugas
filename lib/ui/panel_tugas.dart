import 'package:flutter/material.dart';

import '../model/tugas.dart';

class PanelTugas extends StatefulWidget {
  const PanelTugas({
    super.key,
    required this.judul,
    required this.daftar,
    required this.total,
    required this.jumlahSelesai,
    required this.galat,
    required this.filterAktif,
    required this.onFilter,
    required this.onTambah,
    required this.onUbahStatus,
  });

  final String judul;
  final List<Tugas> daftar;
  final int total; 
  final int jumlahSelesai;
  final String? galat;
  final bool filterAktif;
  final ValueChanged<bool> onFilter;
  final bool Function(String) onTambah;
  final ValueChanged<int> onUbahStatus;

  @override
  State<PanelTugas> createState() => _PanelTugasState();
}

class _PanelTugasState extends State<PanelTugas> {
  final TextEditingController _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _simpan() {
    if (widget.onTambah(_input.text)) _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.judul)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            key: const ValueKey('judul-tugas'),
            controller: _input,
            decoration: InputDecoration(
              labelText: 'Judul tugas',
              hintText: 'Contoh: Rancang UI Flutter',
              border: const OutlineInputBorder(),
              errorText: widget.galat,
            ),
            onSubmitted: (_) => _simpan(),
          ),
          const SizedBox(height: 10),
          FilledButton(onPressed: _simpan, child: const Text('Tambah tugas')),
          const SizedBox(height: 22),
          Text(
            '${widget.jumlahSelesai} dari ${widget.total} selesai',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: FilterChip(
              key: const ValueKey('filter-belum-selesai'),
              label: const Text('Belum selesai'),
              selected: widget.filterAktif,
              onSelected: widget.onFilter,
            ),
          ),
          const Divider(),
          if (widget.daftar.isEmpty)
            Text(
              widget.total == 0
                  ? 'Belum ada tugas.'
                  : 'Tidak ada tugas yang belum selesai.',
            ),
          for (final tugas in widget.daftar)
            CheckboxListTile(
              key: ValueKey(tugas.id),
              title: Text(tugas.judul),
              value: tugas.selesai,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (_) => widget.onUbahStatus(tugas.id),
            ),
        ],
      ),
    );
  }
}