import 'dart:async';
import 'package:flutter/material.dart';
import 'task_page.dart'; // pastikan file ini ada di folder yang sama
import '../back/class_service.dart';
import '../back/login_sign_service.dart';

// This page will fetch jadwal from API and filter per mahasiswa (prodi + kelas)

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final Color primaryRed = const Color(0xFFB71C1C);
  int _selectedIndex = 1; // class di tengah (index 1)
  late DateTime _today;
  late Timer _timer;
  String userName = 'LiA';

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {
          _today = DateTime.now();
        });
      }
    });
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      // Prefer nama mahasiswa from mahasiswa profile (if available)
      final mahasiswa = await AuthService.getMahasiswa();
      final namaMahasiswa = (mahasiswa['nama'] as String?)?.trim();
      if (mounted && namaMahasiswa != null && namaMahasiswa.isNotEmpty) {
        setState(() => userName = namaMahasiswa);
        return;
      }

      // Fallback to basic stored userName
      final name = await AuthService.getUserName();
      if (mounted && name != null && name.isNotEmpty) {
        setState(() => userName = name);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatFullDate(DateTime dt) {
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    String dayName = days[dt.weekday % 7];
    String monthName = months[dt.month - 1];
    return "$dayName, ${dt.day} $monthName ${dt.year}";
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      // tetap di class page
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/edit');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatFullDate(_today);
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        title: Text(
          'Hi, $userName!',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
          ),
        ],
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadJadwalForStudent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data;
          // expected shape: {"items": List<Map>, "student": Map}
          final List<Map<String, dynamic>> items =
              (data?['items'] as List<Map<String, dynamic>>?) ?? [];
          final Map<String, dynamic>? student =
              data?['student'] as Map<String, dynamic>?;

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              const SizedBox(height: 4),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),

              Text(
                // show student's kelas/prodi or fallback text
                student != null
                    ? 'Jadwal untuk ${student['prodi'] ?? ''} - ${student['kelas'] ?? ''}'
                    : 'Jadwal',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),

              if (items.isEmpty)
                const Center(child: Text('belum ada jadwal untuk anda'))
              else
                ...items.map((it) {
                  // render each jadwal entry
                  final title = it['title'] ?? 'Mata Kuliah';
                  final dosen = 'Dosen: ${it['dosen'] ?? it['dosenId'] ?? ''}';
                  final kelas = it['kelas'] ?? '';
                  final color = primaryRed;
                  return _classCard(title, dosen, kelas, color);
                }).toList(),

              const SizedBox(height: 70),
            ],
          );
        },
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFB71C1C),
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: "Class",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  // Fetch jadwal from API, then filter by current student's prodi & kelas.
  Future<Map<String, dynamic>> _loadJadwalForStudent() async {
    try {
      final student = await AuthService.getMahasiswa();

      final jadwalResponse = await ClassService.getAllJadwal();

      // jadwalResponse expected shape: {statusCode: int, data: {data: [...]}}
      if (jadwalResponse['statusCode'] != 200) {
        return {'items': <Map<String, dynamic>>[], 'student': student};
      }

      final raw = jadwalResponse['data'];
      List<dynamic> list = [];
      if (raw is Map && raw['data'] is List) {
        list = raw['data'];
      } else if (raw is List) {
        list = raw;
      }

      // Filter by student's prodi and kelas if available
      final String? prodi = (student['prodi'] as String?)?.toLowerCase();
      final String? kelas = (student['kelas'] as String?)?.toLowerCase();

      final filtered =
          list
              .where((e) {
                try {
                  final itemProdi = (e['prodi'] ?? '').toString().toLowerCase();
                  final itemKelas = (e['kelas'] ?? '').toString().toLowerCase();
                  if ((prodi?.isNotEmpty ?? false) &&
                      (kelas?.isNotEmpty ?? false)) {
                    return itemProdi == prodi && itemKelas == kelas;
                  } else if ((prodi?.isNotEmpty ?? false)) {
                    return itemProdi == prodi;
                  } else if ((kelas?.isNotEmpty ?? false)) {
                    return itemKelas == kelas;
                  }
                  return false; // no student info -> no match
                } catch (_) {
                  return false;
                }
              })
              .map<Map<String, dynamic>>((e) {
                // Map to fields used in UI
                return {
                  'id': e['id'],
                  'title': 'Matkul ${e['matkulId']}',
                  'dosen': e['dosenId']?.toString() ?? '',
                  'kelas': e['kelas'] ?? '',
                  'hari': e['hari'] ?? '',
                  'jamMulai': e['jamMulai'] ?? '',
                  'jamSelesai': e['jamSelesai'] ?? '',
                };
              })
              .toList();

      return {'items': filtered, 'student': student};
    } catch (e) {
      return {'items': <Map<String, dynamic>>[], 'student': null};
    }
  }

  Widget _classCard(String title, String lecturer, String code, Color bgColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskPage(classTitle: title, lecturer: lecturer),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            lecturer,
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
