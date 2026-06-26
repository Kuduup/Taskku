import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';
import 'tambah_tugas_page.dart';
import 'edit_tugas_page.dart';

class DashboardPage extends StatefulWidget {
  final String userId;

  const DashboardPage({
    super.key,
    required this.userId,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  List tugas = [];
  List semuaTugas = [];

  int total = 0;
  int belum = 0;
  int selesai = 0;

  String filter = "Semua";

  @override
  void initState() {
    super.initState();
    getTugas();
  }

  Future<void> getTugas() async {

    try{

      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2/taskku_api/get_tugas.php?user_id=${widget.userId}",
        ),
      );

      if(response.statusCode==200){

        final List hasil = jsonDecode(response.body);

        total = hasil.length;
        belum = 0;
        selesai = 0;

        for(var item in hasil){

          if(item["status"]=="Belum Selesai"){
            belum++;
          }else{
            selesai++;
          }

        }

        setState(() {

          semuaTugas = hasil;
          tugas = List.from(hasil);

        });

      }

    }catch(e){

      debugPrint(e.toString());

    }

  }

  void filterTugas(String status){

    filter = status;

    setState(() {

      if(status=="Semua"){

        tugas = List.from(semuaTugas);

      }else{

        tugas = semuaTugas.where((item){

          return item["status"]==status;

        }).toList();

      }

    });

  }

  Color warnaStatus(String status){

    if(status=="Selesai"){
      return Colors.green;
    }

    return Colors.orange;

  }

  Widget statistik({

    required String judul,
    required int jumlah,
    required IconData icon,
    required Color warna,

  }){

    bool aktif = filter==judul ||
        (judul=="Total" && filter=="Semua");

    return Expanded(

      child: InkWell(

        borderRadius: BorderRadius.circular(18),

        onTap: (){

          if(judul=="Total"){
            filterTugas("Semua");
          }else if(judul=="Belum"){
            filterTugas("Belum Selesai");
          }else{
            filterTugas("Selesai");
          }

        },

        child: AnimatedContainer(

          duration: const Duration(milliseconds: 250),

          margin: const EdgeInsets.symmetric(horizontal: 4),

          padding: const EdgeInsets.symmetric(vertical: 18),

          decoration: BoxDecoration(

            color: warna,

            borderRadius: BorderRadius.circular(18),

            border: aktif
                ? Border.all(
                    color: Colors.white,
                    width: 3,
                  )
                : null,

            boxShadow: const [

              BoxShadow(

                color: Colors.black12,

                blurRadius: 8,

                offset: Offset(0,3),

              )

            ],

          ),

          child: Column(

            children: [

              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),

              const SizedBox(height:10),

              Text(

                judul,

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 14,

                ),

              ),

              const SizedBox(height:5),

              Text(

                jumlah.toString(),

                style: const TextStyle(

                  color: Colors.white,

                  fontWeight: FontWeight.bold,

                  fontSize: 24,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "TaskKu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: RefreshIndicator(

        onRefresh: getTugas,

        child: ListView(

          padding: const EdgeInsets.all(16),

          children: [

            Row(

              children: [

                statistik(
                  judul: "Total",
                  jumlah: total,
                  icon: Icons.assignment,
                  warna: Colors.blue,
                ),

                statistik(
                  judul: "Belum",
                  jumlah: belum,
                  icon: Icons.pending_actions,
                  warna: Colors.orange,
                ),

                statistik(
                  judul: "Selesai",
                  jumlah: selesai,
                  icon: Icons.check_circle,
                  warna: Colors.green,
                ),

              ],

            ),

            const SizedBox(height: 22),

            Row(

              children: [

                const Icon(
                  Icons.list_alt,
                  color: Colors.blue,
                ),

                const SizedBox(width: 8),

                const Text(

                  "Daftar Tugas",

                  style: TextStyle(

                    fontSize: 22,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                const Spacer(),

                Container(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.blue.shade50,

                    borderRadius: BorderRadius.circular(20),

                  ),

                  child: Text(

                    filter,

                    style: const TextStyle(

                      color: Colors.blue,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ),

              ],

            ),

            const SizedBox(height: 16),

            if (tugas.isEmpty)

              Container(

                padding: const EdgeInsets.only(top: 80),

                alignment: Alignment.center,

                child: Column(

                  children: [

                    Icon(
                      Icons.assignment_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Belum ada tugas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Tekan tombol + untuk menambahkan tugas",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                  ],

                ),

              )

            else

              ...tugas.map((item) {

                return Card(

                  elevation: 4,

                  margin: const EdgeInsets.only(bottom: 15),

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(18),

                  ),                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTugasPage(
                            tugas: item,
                          ),
                        ),
                      );

                      await getTugas();
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Row(
                            children: [

                              const Icon(
                                Icons.menu_book,
                                color: Colors.blue,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  item["mata_kuliah"],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: warnaStatus(item["status"]),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item["status"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            ],
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [

                              const Icon(
                                Icons.assignment,
                                color: Colors.orange,
                                size: 18,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  item["nama_tugas"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Icon(
                                Icons.description,
                                color: Colors.grey,
                                size: 18,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  item["deskripsi"],
                                ),
                              ),

                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [

                              const Icon(
                                Icons.calendar_today,
                                color: Colors.red,
                                size: 18,
                              ),

                              const SizedBox(width: 8),

                              Text(item["deadline"]),

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                );

              }).toList(),

            const SizedBox(height: 80),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TambahTugasPage(
                userId: widget.userId,
              ),
            ),
          );

          await getTugas();

        },
      ),

    );
  }
}