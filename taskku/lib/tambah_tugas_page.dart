import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahTugasPage extends StatefulWidget {
  final String userId;

  const TambahTugasPage({
    super.key,
    required this.userId,
  });

  @override
  State<TambahTugasPage> createState() => _TambahTugasPageState();
}

class _TambahTugasPageState extends State<TambahTugasPage> {
  final mataKuliah = TextEditingController();
  final namaTugas = TextEditingController();
  final deskripsi = TextEditingController();
  final deadline = TextEditingController();

  bool isLoading = false;

  Future pilihTanggal() async {
    DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (tanggal != null) {
      deadline.text =
          "${tanggal.year}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}";
    }
  }

  Future simpan() async {
    if (mataKuliah.text.isEmpty ||
        namaTugas.text.isEmpty ||
        deskripsi.text.isEmpty ||
        deadline.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua data wajib diisi"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    var response = await http.post(
      Uri.parse(
        "http://10.0.2.2/taskku_api/tambah_tugas.php",
      ),
      body: {
        "user_id": widget.userId,
        "mata_kuliah": mataKuliah.text,
        "nama_tugas": namaTugas.text,
        "deskripsi": deskripsi.text,
        "deadline": deadline.text,
        "status": "Belum Selesai",
      },
    );

    var data = jsonDecode(response.body);

    setState(() {
      isLoading = false;
    });

    if (data["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tugas berhasil ditambahkan"),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"]),
        ),
      );
    }
  }

  Widget inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Tambah Tugas"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 10),

            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.assignment_add,
                color: Colors.white,
                size: 45,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Tambah Tugas",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const Text(
              "Isi data tugas kuliah",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [

                    inputField(
                      controller: mataKuliah,
                      label: "Mata Kuliah",
                      icon: Icons.menu_book,
                    ),

                    inputField(
                      controller: namaTugas,
                      label: "Nama Tugas",
                      icon: Icons.assignment,
                    ),

                    inputField(
                      controller: deskripsi,
                      label: "Deskripsi",
                      icon: Icons.description,
                      maxLines: 3,
                    ),

                    inputField(
                      controller: deadline,
                      label: "Deadline",
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: pilihTanggal,
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                        ),

                        onPressed: isLoading ? null : simpan,

                        child: isLoading
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "SIMPAN TUGAS",
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}