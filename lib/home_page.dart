import 'package:flutter/material.dart';
import 'course_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color primaryRed = const Color(0xFFB71C1C);
  int _selectedIndex = 0; // Home aktif

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/edit');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/notification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: primaryRed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Notifikasi",
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // HEADER DENGAN GRADIENT
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB71C1C), // merah tua
                  Color(0xFFD32F2F), // merah medium
                  Color(0xFFE57373), // merah muda
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Hi, LiA!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Sabtu, 19 Juni 2025',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
              ],
            ),
          ),

          // KONTEN SCROLLABLE
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const Text(
                    'Mata Kuliah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _courseCard(
                    context,
                    'Jaringan Komputer',
                    'Yasir Arafat',
                    'TI-11',
                    true,
                  ),
                  _courseCard(
                    context,
                    'Rekayasa Perangkat Lunak',
                    'Yusril Eka Mahendra',
                    'TI-4',
                    false,
                  ),
                  _courseCard(
                    context,
                    'Pemrograman Web',
                    'Ferry Faisal',
                    'TI-12',
                    true,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tugas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _taskCard('PBL Kelompok', 'Sept 25', true),
                  _taskCard('Project RPL', 'Sept 30', false),
                  _taskCard('Project Pemrograman Web', 'Okt 9', true),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _courseCard(
    BuildContext context,
    String title,
    String dosen,
    String kelas,
    bool isRed,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isRed ? primaryRed : const Color(0xFFF4C1C1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(dosen, style: const TextStyle(color: Colors.white70)),
        trailing: Text(
          kelas,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => CourseDetailPage(
                    title: title,
                    dosen: dosen,
                    kelas: kelas,
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget _taskCard(String title, String date, bool isRed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isRed ? primaryRed : const Color(0xFFF4C1C1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          date,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
