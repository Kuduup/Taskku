import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditTugasPage extends StatefulWidget {
  final Map tugas;

  const EditTugasPage({
    super.key,
    required this.tugas,
  });

  @override
  State<EditTugasPage> createState() => _EditTugasPageState();
}

class _EditTugasPageState extends State<EditTugasPage> {
  late TextEditingController mk;
  late TextEditingController nama;
  late TextEditingController deskripsi;
  late TextEditingController deadline;

  String status = "Belum Selesai";

  @override
  void initState() {
    super.initState();

    mk = TextEditingController(
      text: widget.tugas["mata_kuliah"],
    );

    nama = TextEditingController(
      text: widget.tugas["nama_tugas"],
    );

    deskripsi = TextEditingController(
      text: widget.tugas["deskripsi"],
    );

    deadline = TextEditingController(
      text: widget.tugas["deadline"],
    );

    status = widget.tugas["status"];
  }

  Future updateTugas() async {

    if (mk.text.isEmpty ||
        nama.text.isEmpty ||
        deskripsi.text.isEmpty ||
        deadline.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua data wajib diisi"),
        ),
      );

      return;
    }

    var response = await http.post(
      Uri.parse(
        "http://10.0.2.2/taskku_api/edit_tugas.php",
      ),
      body: {
        "id": widget.tugas["id"],
        "mata_kuliah": mk.text,
        "nama_tugas": nama.text,
        "deskripsi": deskripsi.text,
        "deadline": deadline.text,
        "status": status,
      },
    );

    var data = jsonDecode(response.body);

    if (data["success"] == true) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tugas berhasil diperbarui"),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal memperbarui tugas"),
        ),
      );

    }
  }

  Future hapusTugas() async {

    var response = await http.post(
      Uri.parse(
        "http://10.0.2.2/taskku_api/hapus_tugas.php",
      ),
      body: {
        "id": widget.tugas["id"],
      },
    );

    var data = jsonDecode(response.body);

    if (data["success"] == true) {

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menghapus tugas"),
        ),
      );

    }
  }

  Widget inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
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
        title: const Text("Edit Tugas"),
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
                Icons.edit_document,
                color: Colors.white,
                size: 45,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Edit Tugas",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const Text(
              "Perbarui data tugas kuliah",
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
                      controller: mk,
                      label: "Mata Kuliah",
                      icon: Icons.menu_book,
                    ),

                    inputField(
                      controller: nama,
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
                    ),

                    const SizedBox(height: 5),

                    DropdownButtonFormField(
                      value: status,
                      decoration: InputDecoration(
                        labelText: "Status",
                        prefixIcon: const Icon(Icons.flag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Belum Selesai",
                          child: Text("Belum Selesai"),
                        ),
                        DropdownMenuItem(
                          value: "Selesai",
                          child: Text("Selesai"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          status = value.toString();
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: updateTugas,
                        child: const Text(
                          "UPDATE TUGAS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Konfirmasi"),
                              content: const Text(
                                "Yakin ingin menghapus tugas ini?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Batal"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    hapusTugas();
                                  },
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          "HAPUS TUGAS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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