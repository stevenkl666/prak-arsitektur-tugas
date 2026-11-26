import '../data/repositori_tugas.dart';
import '../model/tugas.dart';

class PengendaliTugas {
  PengendaliTugas(this._repo);
  final RepositoriTugas _repo;
  String? _galat;
  bool _hanyaBelumSelesai = false;

  List<Tugas> get daftar => _repo.daftar;
  String? get galat => _galat;
  bool get hanyaBelumSelesai => _hanyaBelumSelesai;
  int get total => daftar.length;
  int get jumlahSelesai => daftar.where((tugas) => tugas.selesai).length;

  List<Tugas> get daftarTerlihat =>
      _hanyaBelumSelesai
          ? daftar.where((tugas) => !tugas.selesai).toList()
          : daftar;

  bool tambah(String input) {
    _galat = validasiJudul(input);
    if (_galat != null) return false;
    _repo.tambah(input.trim());
    return true;
  }

  void ubahStatus(int id) => _repo.ubahStatus(id);

  void ubahFilter(bool nilai) => _hanyaBelumSelesai = nilai;
  
}
